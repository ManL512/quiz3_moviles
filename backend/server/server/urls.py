from django.contrib import admin
from django.urls import path
from . import views

urlpatterns = [
    path('admin/', admin.site.urls),
    path('register/', views.register),
    path('login/', views.CustomTokenObtainPairView.as_view(), name='token_obtain_pair'),
]
