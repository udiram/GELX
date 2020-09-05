from django.conf import settings
from django.conf.urls.static import static
from django.urls import path
from django.conf.urls import include

from . import views

urlpatterns = [
    path('', views.index, name='index'),
    path('add/', views.add, name='add'),
    path('analysis/', views.analysis, name='analysis'),
    path('upload/', views.image_upload_view),
    path('<int:user_id>/', views.user, name='user'),
    path('user/', views.addUser, name='addUser'),
    path('ladder/', views.addLadder, name='addLadder'),
    path('image/', views.addImage, name='addImage')

]

if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL,
                          document_root=settings.MEDIA_ROOT)