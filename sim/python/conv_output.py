#!/usr/local/bin/python3.6
import os
import sys
import datetime
import fileinput
import math
import re
import numpy as np
np.set_printoptions(linewidth = 256)

############################################
## READ_TXT FUNCTION
############################################
def read_txt(_folder_path, _file_name,x_size,y_size):
  f_in=open(_folder_path+'/'+_file_name,'r')

  ar_pxl = np.zeros((x_size*y_size),dtype = np.uint32)
  
  for index in range(x_size*y_size):
    pixel = int(f_in.readline(),16)
    ar_pxl[index] = pixel

  return ar_pxl
  
############################################
## CREATE_PPM FUNCTION
############################################
def create_ppm(_folder_path,_file_name,_ar,_x_size,_y_size,_max_val):
 
  line_out = '\
P2\n\
'+str(_x_size)+' '+str(_y_size)+'\n\
'+str(_max_val)+'\n'
  try:
    f_out = open(_folder_path+'/'+_file_name,'w')
    f_out.write(line_out)
    for row in range (int(_y_size)):
      for col in range (int(_x_size)):
        f_out.write(str(_ar[row*_x_size+col])+'\t')
      f_out.write('\n')

  finally:
    f_out.close()
  return
  
############################################
## MAIN
############################################
if __name__ == '__main__':

  # Define variables
  folder_path = './'
  
  filename = 'landscape_large'
  x_size = 640
  y_size = 480

  ############################
  ## GAUSS STEP
  ############################
  max_val = 2**8-1
  x_size = x_size-2 # -2 because conv 3x3
  y_size = y_size-2 # -2 because conv 3x3
  
  suffix = 'gauss'
  
  if 1:
    # Read txt file
    ar_pxl = read_txt(folder_path,filename+'_8b_'+suffix+'_out.txt',x_size,y_size)

    # create ppm files
    create_ppm(folder_path,filename+'_8b_'+suffix+'_out.ppm',ar_pxl,x_size,y_size,max_val)
    
  ############################
  ## SOBEL STEP
  ############################
  max_val = 2**12-1
  x_size = x_size-2 # -2 because conv 3x3
  y_size = y_size-2 # -2 because conv 3x3
  
  suffix = 'sobel'

  if 1:
    # Read txt file
    ar_pxl = read_txt(folder_path,filename+'_12b_'+suffix+'_out.txt',x_size,y_size)

    # create ppm files
    create_ppm(folder_path,filename+'_12b_'+suffix+'_out.ppm',ar_pxl,x_size,y_size,max_val)

  ############################
  ## NON MAX SUPPR STEP
  ############################
  max_val = 2**12-1
  x_size = x_size-2 # -2 because conv 3x3
  y_size = y_size-2 # -2 because conv 3x3
  
  suffix = 'non_max_suppr'

  if 0:
    # Read txt file
    ar_pxl = read_txt(folder_path,filename+'_12b_'+suffix+'_out.txt',x_size,y_size)

    # create ppm files
    create_ppm(folder_path,filename+'_12b_'+suffix+'_out.ppm',ar_pxl,x_size,y_size,max_val)

  ############################
  ## DOUBLE THRESHOLD STEP
  ############################
  max_val = 2**2-1
  x_size = x_size-0 # -0 because no conv
  y_size = y_size-0 # -0 because no conv
  
  suffix = 'threshold'

  if 1:
    # Read txt file
    ar_pxl = read_txt(folder_path,filename+'_2b_'+suffix+'_out.txt',x_size,y_size)

    # create ppm files
    create_ppm(folder_path,filename+'_2b_'+suffix+'_out.ppm',ar_pxl,x_size,y_size,max_val)
    
  ############################
  ## HYSTERESIS STEP
  ############################
  max_val = 2**1-1
  x_size = x_size-2 # -2 because conv 3x3
  y_size = y_size-2 # -2 because conv 3x3
  
  suffix = 'hysteresis'

  if 1:
    # Read txt file
    ar_pxl = read_txt(folder_path,filename+'_1b_'+suffix+'_out.txt',x_size,y_size)

    # create ppm files
    create_ppm(folder_path,filename+'_1b_'+suffix+'_out.ppm',ar_pxl,x_size,y_size,max_val)
