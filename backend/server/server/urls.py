#urls,py
from django.contrib import admin
from django.urls import path
from . import views

urlpatterns = [
    path('register/', views.register),
    path('login/', views.login),
    path('activate_long_token/', views.activate_long_token),
    path('disable_long_token/', views.disable_long_token),
    path('validate_long_token/', views.validate_long_token),  # Nueva ruta para la validación del long token
]