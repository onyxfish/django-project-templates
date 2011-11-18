from django.conf.urls.defaults import *

# Uncomment the next two lines to enable the admin:
# from django.contrib import admin
# admin.autodiscover()

urlpatterns = patterns('',
    # Example:
    # (r'^simple_project/', include('simple_project.foo.urls')),

    # Uncomment the admin/doc line below to enable admin documentation:
    # (r'^admin/doc/', include('django.contrib.admindocs.urls')),

    # Uncomment the next line to enable the admin:
    # (r'^admin/', include(admin.site.urls)),

    # Should never be used in production, as nginx will server these paths
    (r'^site_media/(?P<path>.*)$', 'django.views.static.serve',
        { 'document_root': settings.MEDIA_ROOT,
            'show_indexes': True }),
)
