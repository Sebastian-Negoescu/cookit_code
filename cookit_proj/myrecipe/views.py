from django.shortcuts import render, get_object_or_404
from django.template import RequestContext
from django.http import HttpResponse
from django.http import Http404
from .models import Recipe

# Create your views here.
def home(request):
    recipes = Recipe.objects.all()
    return render(request, "myrecipe/home.html", {"recipes": recipes})


def recipe_detail(request, id):
    recipe = Recipe.objects.get(id=id)
    return render(request, "myrecipe/recipe_detail.html", {"recipe": recipe})

