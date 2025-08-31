from django.urls import path
from . import views

app_name = 'notes'

urlpatterns = [
    path('', views.list_create, name='list'),
    path('<int:note_id>/delete/', views.delete, name='delete'),
]