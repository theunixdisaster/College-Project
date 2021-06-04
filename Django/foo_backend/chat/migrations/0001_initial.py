# Generated by Django 3.2 on 2021-06-03 01:04

import chat.models
from django.conf import settings
from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='User',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('password', models.CharField(max_length=128, verbose_name='password')),
                ('last_login', models.DateTimeField(blank=True, null=True, verbose_name='last login')),
                ('email', models.EmailField(max_length=255, unique=True, verbose_name='email address')),
                ('f_name', models.CharField(max_length=50)),
                ('l_name', models.CharField(max_length=50)),
                ('username', models.CharField(max_length=50)),
                ('uprn', models.IntegerField(null=True, unique=True)),
                ('token', models.CharField(max_length=240, null=True, unique=True)),
                ('dob', models.DateField(blank=True, null=True)),
                ('is_active', models.BooleanField(default=True)),
                ('staff', models.BooleanField(default=False)),
                ('admin', models.BooleanField(default=False)),
                ('username_alias', models.CharField(blank=True, max_length=100, null=True, unique=True)),
                ('about', models.TextField(default='')),
            ],
            options={
                'abstract': False,
            },
        ),
        migrations.CreateModel(
            name='Story',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('file', models.FileField(upload_to=chat.models.user_story_directory_path)),
                ('caption', models.TextField(max_length=1000)),
                ('time_created', models.DateTimeField(auto_now_add=True)),
                ('user', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='stories', to=settings.AUTH_USER_MODEL)),
                ('views', models.ManyToManyField(blank=True, related_name='story_views', to=settings.AUTH_USER_MODEL)),
            ],
        ),
        migrations.CreateModel(
            name='Thread',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('first', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='first_thred', to=settings.AUTH_USER_MODEL)),
                ('second', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='second_thread', to=settings.AUTH_USER_MODEL)),
            ],
        ),
        migrations.CreateModel(
            name='StoryNotification',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('storyId', models.IntegerField(blank=True, null=True)),
                ('notif_type', models.CharField(choices=[('story_add', 'story_add'), ('story_del', 'story_del'), ('story_view', 'story_view')], max_length=15)),
                ('time_created', models.CharField(max_length=20)),
                ('from_user', models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.CASCADE, related_name='story_viewed_user', to=settings.AUTH_USER_MODEL)),
                ('story', models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.CASCADE, to='chat.story')),
                ('to_user', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to=settings.AUTH_USER_MODEL)),
            ],
        ),
        migrations.CreateModel(
            name='StoryComment',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('comment', models.TextField(max_length=1000)),
                ('time_created', models.DateTimeField(auto_now_add=True)),
                ('story', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='story_comment', to='chat.story')),
                ('user', models.ForeignKey(null=True, on_delete=django.db.models.deletion.CASCADE, to=settings.AUTH_USER_MODEL)),
            ],
        ),
        migrations.CreateModel(
            name='Profile',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('online', models.BooleanField(default=False)),
                ('last_seen', models.DateTimeField(auto_now_add=True)),
                ('profile_pic', models.FileField(blank=True, null=True, upload_to=chat.models.profile_pic_path)),
                ('general_last_seen_off', models.BooleanField(default=False)),
                ('friends', models.ManyToManyField(blank=True, related_name='friends', to=settings.AUTH_USER_MODEL)),
                ('people_i_peek', models.ManyToManyField(blank=True, related_name='watching', to=settings.AUTH_USER_MODEL)),
                ('people_i_should_inform', models.ManyToManyField(blank=True, related_name='cctvs', to=settings.AUTH_USER_MODEL)),
                ('user', models.OneToOneField(on_delete=django.db.models.deletion.CASCADE, to=settings.AUTH_USER_MODEL)),
                ('yall_cant_see_me', models.ManyToManyField(blank=True, related_name='hidden_last_seen', to=settings.AUTH_USER_MODEL)),
            ],
        ),
        migrations.CreateModel(
            name='Post',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('file', models.FileField(upload_to=chat.models.user_directory_path)),
                ('post_type', models.CharField(max_length=15)),
                ('time_created', models.DateTimeField(auto_now_add=True)),
                ('caption', models.CharField(max_length=100)),
                ('thumbnail', models.FileField(blank=True, null=True, upload_to=chat.models.post_thumbnail_path)),
                ('likes', models.ManyToManyField(blank=True, related_name='likes', to=settings.AUTH_USER_MODEL)),
                ('user', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='posts', to=settings.AUTH_USER_MODEL)),
            ],
        ),
        migrations.CreateModel(
            name='Notification',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('ref_id', models.CharField(max_length=20, null=True)),
                ('chatmsg_id', models.IntegerField(null=True)),
                ('notif_type', models.CharField(choices=[('seen', 'seen'), ('received', 'received'), ('s_reached', 's_reached'), ('delete', 'delete')], max_length=10)),
                ('chat_username', models.CharField(blank=True, max_length=100, null=True)),
                ('notif_from', models.ForeignKey(null=True, on_delete=django.db.models.deletion.CASCADE, related_name='from_user_chat', to=settings.AUTH_USER_MODEL)),
                ('notif_to', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='to_user_chat', to=settings.AUTH_USER_MODEL)),
            ],
        ),
        migrations.CreateModel(
            name='MentionNotification',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('post_id', models.IntegerField(blank=True, null=True)),
                ('time_created', models.CharField(blank=True, max_length=70, null=True)),
                ('from_user', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='mention_from_user', to=settings.AUTH_USER_MODEL)),
                ('to_user', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='mention_to_user', to=settings.AUTH_USER_MODEL)),
            ],
        ),
        migrations.CreateModel(
            name='FriendRequest',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('status', models.CharField(choices=[('pending', 'pending'), ('accepted', 'accepted'), ('rejected', 'rejected')], max_length=10)),
                ('has_received', models.BooleanField(default=False)),
                ('time_created', models.CharField(blank=True, max_length=70, null=True)),
                ('from_user', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='from_user', to=settings.AUTH_USER_MODEL)),
                ('to_user', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='to_user', to=settings.AUTH_USER_MODEL)),
            ],
        ),
        migrations.CreateModel(
            name='Comment',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('comment', models.CharField(max_length=1000)),
                ('time_created', models.DateTimeField(auto_now_add=True)),
                ('mentions', models.ManyToManyField(blank=True, to=settings.AUTH_USER_MODEL)),
                ('post', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='chat.post')),
                ('user', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='mentions', to=settings.AUTH_USER_MODEL)),
            ],
        ),
        migrations.CreateModel(
            name='ChatMessage',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('message', models.TextField(blank=True, null=True)),
                ('time_created', models.CharField(max_length=30, null=True)),
                ('msg_type', models.CharField(blank=True, choices=[('msg', 'msg'), ('img', 'img'), ('aud', 'aud'), ('reply_txt', 'reply_txt'), ('reply_img', 'reply_img'), ('reply_txt', 'reply_txt')], max_length=10, null=True)),
                ('file', models.FileField(null=True, upload_to=chat.models.media_path)),
                ('reply_txt', models.TextField(blank=True, null=True)),
                ('reply_id', models.IntegerField(blank=True, null=True)),
                ('recipients', models.ManyToManyField(blank=True, to=settings.AUTH_USER_MODEL)),
                ('thread', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='chat.thread')),
                ('user', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='sender', to=settings.AUTH_USER_MODEL)),
            ],
        ),
    ]
