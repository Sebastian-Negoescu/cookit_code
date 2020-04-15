from django.db import models

# Create your models here.
class Recipe(models.Model):
    title = models.CharField(max_length=150)
    description = models.TextField(max_length=3000)

    def __str__(self):
        return f"{self.title}"