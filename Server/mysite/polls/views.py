# -*- coding: utf-8 -*-
import base64
import json
import os
from datetime import datetime

from django.core import serializers
from django.core.files.base import ContentFile
from django.http import HttpResponse, JsonResponse
from django.shortcuts import render, get_object_or_404
from django.views.decorators.csrf import csrf_exempt

from polls.forms import ImageForm

from polls.models import *



def index(request):
    return HttpResponse("Hello, world. You're at the polls index.")


def add(request):
    return HttpResponse("Result: 4")


@csrf_exempt
def analysis(request):
    if request.method == "POST":
        body_unicode = request.body.decode('utf-8')
        json_data = json.loads(body_unicode)

        sumX = 0
        sumY = 0
        for val in json_data:
            sumX += val['x']
            sumY += val['y']

        print(str(sumX) + ":::" + str(sumY))

    return HttpResponse("Data Received for analysis! " + "Sum of X values" + str(sumX) + ":::" + "Sum of Y values"
                        + str(sumY))


def image_upload_view(request):
    """Process images uploaded by users"""
    if request.method == 'POST':
        form = ImageForm(request.POST, request.FILES)
        if form.is_valid():
            form.save()
            # Get the current instance object to display in the template
            img_obj = form.instance
            return render(request, 'index.html', {'form': form, 'img_obj': img_obj})
    else:
        form = ImageForm()
    return render(request, 'index.html', {'form': form})


def user(request, user_id):
    # users = User.objects.get(user_id)
    # qs_json = serializers.serialize('json', users)
    # return HttpResponse(qs_json, content_type='application/json')
    userObj = get_object_or_404(User, pk=user_id)
    return HttpResponse(userObj)


@csrf_exempt
def addUser(request):
    if request.method == "POST":
        body_unicode = request.body.decode('utf-8')
        json_data = json.loads(body_unicode)
        u = User(username=json_data['username'], password=json_data['password'])
        u.save()

    return HttpResponse("New user created: " + str(u.user_id))


@csrf_exempt
def addLadder(request):
    if request.method == "POST":
        body_unicode = request.body.decode('utf-8')
        json_data = json.loads(body_unicode)
        l = LadderData(user_id=json_data['user_id'], ladder_point=json_data['ladder_point'],
                       ladder_length=json_data['ladder_length'])
        l.save()

        return HttpResponse("Ladder data saved successfully" + str(l.user_id))


@csrf_exempt
def removeLadder(request):
    if request.method == "POST":
        body_unicode = request.body.decode('utf-8')
        json_data = json.loads(body_unicode)
        l = LadderData(user_id=json_data['user_id'], ladder_point=json_data['ladder_point'],
                       ladder_length=json_data['ladder_length'])
        l.delete()

        return HttpResponse("Ladder data deleted successfully" + str(l.user_id))


@csrf_exempt
def addImage(request):

    ts = datetime.now().timestamp()
    readable = datetime.fromtimestamp(ts).isoformat()

    if request.method == "POST":
        body_unicode = request.body.decode('utf-8')
        json_data = json.loads(body_unicode)
        i = GelImage(job_id=json_data['job_id'], image=ContentFile(base64.urlsafe_b64decode(json_data['image'])))

        i.image.save(
            os.path.basename(readable + ".png"),
            ContentFile(base64.urlsafe_b64decode(json_data['image']))
        )
        i.save()

        return HttpResponse("image data saved successfully," + " " + "job id:" + " " + str(i.job_id))
