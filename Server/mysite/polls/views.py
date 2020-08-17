# -*- coding: utf-8 -*-
import json

from django.http import HttpResponse
from django.shortcuts import render
from django.views.decorators.csrf import csrf_exempt

from polls.forms import ImageForm


def index(request):
    return HttpResponse("Hello, world. You're at the polls index.")


def add(request):
    return HttpResponse("Result: 4")


@csrf_exempt
def analysis(request):
    if request.method == "POST":
        body_unicode = request.body.decode('utf-8')
        json_data = json.loads(body_unicode)
        jsonLen = len(json_data)

        sumX = 0
        sumY = 0
        for val in json_data:
            sumX += val['x']
            sumY += val['y']

        print(str(sumX) + ":::" + str(sumY))

    return HttpResponse("Data Received for analysis! " + "Sum of X values"  + str(sumX) + ":::" + "Sum of Y values"
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
