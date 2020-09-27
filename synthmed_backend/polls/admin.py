# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.contrib import admin

from .models import User, Jobs, Image, LadderData, GelImage

admin.site.register(User)
admin.site.register(Jobs)
admin.site.register(Image)
admin.site.register(LadderData)
admin.site.register(GelImage)
