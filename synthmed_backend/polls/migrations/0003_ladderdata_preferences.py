# Generated by Django 3.0.8 on 2020-08-23 16:57

from django.db import migrations, models
import django.utils.timezone


class Migration(migrations.Migration):

    dependencies = [
        ('polls', '0002_jobs_ladderdata_user'),
    ]

    operations = [
        migrations.AddField(
            model_name='ladderdata',
            name='preferences',
            field=models.CharField(default=django.utils.timezone.now, max_length=1000),
            preserve_default=False,
        ),
    ]
