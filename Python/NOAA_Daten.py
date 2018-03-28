#!/usr/bin/env python2
# -*- coding: utf-8 -*-
"""
Created on Tue Mar 13 14:33:26 2018

@author: Katharina Enigl
"""


from netCDF4 import Dataset
import matplotlib.pyplot as plt
from mpl_toolkits.basemap import Basemap
import numpy as np

dataset =Dataset('/home/datascience/starting-kit/auxiliaryData/adapt/aux/NOAA_NCOM_Region2/X11/X1278720000.nc/Data/ncom_glb_regp02_2010071000.nc', mode='r') 
print dataset.variables.keys()

lons = dataset.variables['lon'][:]
lats = dataset.variables['lat'][:]
salinity = dataset.variables['salinity'][:]
depth=dataset.variables['depth'][:]
surf_el= dataset.variables['surf_el'][:]
tau= dataset.variables['tau'][:]
water_temp=dataset.variables['water_temp'][:]
water_u=dataset.variables['water_u'][:]
water_v=dataset.variables['water_v'][:]
times=dataset.variables['time'][:]

print dataset.variables['surf_el']
print dataset.variables['tau']
print dataset.variables['depth']
print dataset.variables['water_temp']
print dataset.variables['salinity']

dataset.close()

def make_map():
    fig, ax = plt.subplots(figsize=(16,9))
    map = Basemap(projection='lcc',lat_0=20, lon_0=10,llcrnrlon=-50., llcrnrlat=15., urcrnrlon=80., urcrnrlat=70., resolution='h')
    map.drawmapboundary(fill_color='w')
    map.fillcontinents(color='#cc9966',lake_color='#99ffff')
    map.drawcoastlines() 
    map.drawparallels(np.arange(0.,90.,1.),color='gray',dashes=[1,3],labels=[1,0,0,0])
    map.drawmeridians(np.arange(0.,360.,5.),color='gray',dashes=[1,3],labels=[0,0,0,1])
    
    return fig, map

fig, map=make_map()

X,Y=np.meshgrid(lons, lats)
x, y=map(X,Y)


surf_el=map.contourf(x,y,surf_el[0,:,:]) #erste Nummer (0) ist der Zeitpunkt (geht von 0-8)
cb = map.colorbar(surf_el,"bottom", size="5%", pad="8%")
plt.title('Water Surface Elevation', fontsize='18', fontweight='bold')
cb.set_label('Water Surface Elevation [m]')
plt.savefig('surf_el.png', dpi=300, facecolor='w', edgecolor='w')
plt.show()      

fig, map=make_map()

water_temp=map.contourf(x,y,water_temp[0,1,:,:], cmap='coolwarm') #0 beschreibt wieder den Zeitpunkt, 1 das vertikale Level (geht bis 40)
cb = map.colorbar(water_temp,"bottom", size="5%", pad="8%")
plt.title('Water Temperature', fontsize='18', fontweight='bold')
cb.set_label('Water Temperature [degC]')
plt.savefig('water_temp.png', dpi=300, facecolor='w', edgecolor='w')
plt.show()

fig, map=make_map()

salinity=map.contourf(x,y,salinity[0,1,:,:], cmap='jet') #0 beschreibt wieder den Zeitpunkt, 1 das vertikale Level (geht bis 40)
cb = map.colorbar(salinity,"bottom", size="5%", pad="8%")
plt.title('Salinity', fontsize='18', fontweight='bold')
cb.set_label('Salinity [psu]')
plt.savefig('salinity.png', dpi=300, facecolor='w', edgecolor='w')
plt.show()
