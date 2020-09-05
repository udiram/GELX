# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models


# Create your models here.
class Image(models.Model):
    title = models.CharField(max_length=200)
    image = models.ImageField(upload_to='images')

    def __str__(self):
        return self.title


class GelImage(models.Model):
    job_id = models.IntegerField()
    image = models.ImageField(upload_to='gel_images')

    def __str__(self):
        return str(self.job_id)

class User(models.Model):
    user_id = models.AutoField(primary_key=True)
    username = models.CharField(max_length=200)
    password = models.CharField(max_length=200)

    def __str__(self):
        return self.username + " " + str(self.user_id) + " " + self.password


class LadderData(models.Model):
    user_id = models.IntegerField()
    ladder_point = models.IntegerField()
    ladder_length = models.IntegerField()

    def __str__(self):
        return "UserId: " + str(self.user_id) + "Point: " + str(self.ladder_point) + " Length: " + str(
            self.ladder_length)


class Jobs(models.Model):
    user_id = models.IntegerField()
    job_id = models.AutoField(primary_key=True)

    def __str__(self):
        return str(self.user_id) + " " + self.job_id
