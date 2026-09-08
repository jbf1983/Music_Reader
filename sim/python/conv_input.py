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
## READ_PPM FUNCTION
############################################
def read_ppm(_folder_path,_file_name):
  f_in=open(_folder_path+'/'+_file_name,'r')

  f_in.readline() # P2
  line = f_in.readline() # x_size y_size
  x_size = int(line.split()[0])
  y_size = int(line.split()[1])
  max_val = f_in.readline() # max val

  ar_pxl = np.zeros((y_size, x_size),dtype = np.uint32)
  for row in range(y_size):
    line = f_in.readline()
    ar_pxl[row] = line.split()

  return x_size,y_size,max_val,ar_pxl
  
############################################
## WRITE_PPM FUNCTION
############################################
def write_ppm(_folder_path,_file_name,_ar,_max_val):
 
  line_out = '\
P2\n\
'+str(_ar.shape[1])+' '+str(_ar.shape[0])+'\n\
'+str(_max_val)+'\n'
  try:
    f_out = open(_folder_path+'/'+_file_name,'w')
    f_out.write(line_out)
    for row in _ar:
      for col in row:
        f_out.write(str(col)+' ')
      f_out.write('\n')

  finally:
    f_out.close()
  return

############################################
## WRITE_TXT FUNCTION
############################################
def write_txt(_folder_path,_file_name,_ar,_max_val):
 
  try:
    f_out = open(_folder_path+'/'+_file_name,'w')
    for row in _ar:
      for col in row:
        f_out.write(str(format(col,'x'))+'\n')

  finally:
    f_out.close()
  return
  
############################################
## MAIN
############################################
if __name__ == '__main__':

  # Define variables
  folder_path = './'

  ##########################
  ## OUTPUT 8 bits
  ##########################
  if 1:
    max_val = 2**8-1

    filename = 'landscape_large'
    # Read file
    ar_pxl = read_ppm(folder_path,filename+'.ppm')[3]
    ar_pxl = ar_pxl.astype(int) >> 8

    # Write ppm files
    write_ppm(folder_path,filename+'_8b.ppm',ar_pxl,max_val)

    # Write txt files
    write_txt(folder_path,filename+'_8b.txt',ar_pxl,max_val)
