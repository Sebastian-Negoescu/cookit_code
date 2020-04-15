from django.contrib import admin
from .models import Recipe

# Register your models here.
@admin.register(Recipe)
class MyRecipe(admin.ModelAdmin):
    list_display = ["id", "title", "description"]