from django.db import models
from django_extensions.db.fields import AutoSlugField
from django.utils.translation import ugettext_lazy as _
# Create your models here.
class Recipe(models.Model):
    name = models.CharField(max_length=150)
    slug = AutoSlugField(_('slug'), populate_from='name', unique=True)
    description = models.TextField(max_length=3000)

    def __unicode__(self):
        return self.name

    
    def get_absolute_uri(self):
        return f"/myrecipe/{self.slug}/"


    

# TO DO: besides the Recipe/Retete model, add "ingrediente" as one field with list "items property" && "images" for various photos that are to be uploaded for representation