from netCDF4 import Dataset
import matplotlib
import matplotlib.pyplot as plt
import numpy as np
ldas = Dataset('201108290000.LDASOUT_DOMAIN1', 'r')
ldas_vars = ldas.variables
VolumetricSoilMoisture = ldas_vars['SOIL_W'][:]
VSM_Layer0 = np.flip(VolumetricSoilMoisture[0,:,0,:], 0)
VSM_Layer1 = np.flip(VolumetricSoilMoisture[0,:,1,:], 0)
VSM_Layer2 = np.flip(VolumetricSoilMoisture[0,:,2,:], 0)
VSM_Layer3 = np.flip(VolumetricSoilMoisture[0,:,3,:], 0)
SurfaceRunoff = ldas_vars['UGDRNOFF'][:]
SurfaceRunoff = np.flip(SurfaceRunoff[0,:,:], 0)
fig = plt.figure(figsize=(6,6),dpi=200)
im = plt.imshow(SurfaceRunoff, vmin=0.0, vmax=300)
cb = fig.colorbar(im, orientation='horizontal')
cb.set_label('Surface runoff (mm)')
plt.savefig('SurfaceRunoff.pdf')
