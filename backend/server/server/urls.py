from django.contrib import admin
from django.urls import path
from . import views

urlpatterns = [
    path('admin/', admin.site.urls),
    path('register/', views.register),
    path('login/', views.login, name='login'),
    path('activate_long_token/', views.activate_long_token, name='activate_long_token'),
]
