# Keras-model-to-Ios

# Mac 
下載Anaconda Navigator python 2.7版
因為CoreML不支援python3最多支援2.7
下載完後開啟 Anaconda terminal
安裝
tensorflow 1.13.1 keras 2.2.4 & 2.3.1 coremltools 3.0b6

  python2 -m pip install --upgrade pip
  python2 -m pip install --upgrade https://storage.googleapis.com/tensorflow/mac/cpu/tensorflow-1.13.1-py2-none-any.whl
  pip install -U coremltools==3.0b6 keras==2.2.4
  這邊keras 網路上查是說用2.2.4，但後轉換成CoreML model的時候出現錯誤
  後來更新至2.3.1就解決了...這邊坑蠻大的如果有出現這問題請升級keras
import coremltools
# import numpy
# from keras.models import Sequential
# from keras.layers import Dense
# from keras.layers import Dropout
# from keras.utils import np_utils
from keras.models import load_model

class_labels = ['Apple Red 2', 'Apricot', 'Banana Lady Finger', 'Cantaloupe 1', 'Carambula', 'Cherry 2',
                 'Corn', 'Ginger Root', 'Strawberry Wedge', 'Tomato Cherry Red','Watermelon']

# model = load_model('cnn_model.h5', compile=False)
model = load_model('cnn_model1.h5')

coreml_model = coremltools.converters.keras.convert(model, input_names=['image'], output_names=['output'],image_input_names='image')

coreml_model.author = 'jed'
coreml_model.short_description = 'furit'
coreml_model.input_description['image'] = '64*64 image'
coreml_model.output_description['output'] = 'Apple Red 2, Apricot, Banana Lady Finger, Cantaloupe 1, Carambula,Cherry 2,Corn, Ginger Root, Strawberry Wedge,Tomato Cherry Red,Watermelon'


coreml_model.save('xx.mlmodel')
