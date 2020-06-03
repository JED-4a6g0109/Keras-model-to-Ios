# Keras-model-to-Ios

## 訓練資料
https://www.kaggle.com/moltean/fruits<br>

## Keras traing model
請參照keras_model&CoreML檔案<br>
如果是Mac直接全部執行<br>
如果是windwon執行至 model pred那段<br>
後面CoreML是需要在Mac下轉換<br>
訓練完後能save和load model就OK了<br>

## Mac(只能用Mac把Keras model to CoreML model)
要注意windwon是不能轉的因為pip install coremltools==3.0b6載不到，用別版也是轉失敗<br>
下載Anaconda Navigator python 2.7版<br>
因為CoreML不支援python3最多支援2.7<br>
下載完後開啟 Anaconda terminal<br>
安裝tensorflow 1.13.1 keras 2.2.4 & 2.3.1 coremltools 3.0b6<br>

    python2 -m pip install --upgrade pip
    python2 -m pip install --upgrade https://storage.googleapis.com/tensorflow/mac/cpu/tensorflow-1.13.1-py2-none-any.whl
    pip install -U coremltools==3.0b6 keras==2.2.4
    
這邊keras 網路上查是說用2.2.4，但後轉換成CoreML model的時候出現錯誤<br>
TypeError: Unexpected keyword argument passed to optimizer: learning_rate<br>
當初用compile = False能轉成供但在xcode調用model會有問題[1]<br>
後來更新至2.3.1就解決了...這邊坑蠻大的如果有出現這問題請升級keras[2]<br>

### 查看版本
都下載完後打pip list查看版本<br>
tensorboard                        1.13.1<br>
tensorflow                         1.13.1<br>
tensorflow-estimator               1.13.0<br>
Keras                              2.3.1<br>
Keras-Applications                 1.0.8<br>
Keras-Preprocessing                1.1.2<br>
coremltools                        3.0b6<br>
## keras model to CoreML model code
    import coremltools
    from keras.models import load_model
    model = load_model('cnn_model1.h5')
    coreml_model = coremltools.converters.keras.convert(model, input_names=['image'], output_names=['output'],image_input_names='image')
    coreml_model.author = 'jed'
    coreml_model.short_description = 'furit'
    coreml_model.input_description['image'] = '64*64 image'
    coreml_model.output_description['output'] = 'Apple Red 2, Apricot, Banana Lady Finger, Cantaloupe 1, Carambula,Cherry 2,Corn, Ginger   Root, Strawberry Wedge,Tomato Cherry Red,Watermelon'
    coreml_model.save('xx.mlmodel')
    
 如果轉換成功後會多一個xx.mlmodel檔案<br>
 
 ## xocde use mlmodel
 開啟Xcode 把xx.mlmodel移至Xcode專案裡面<br>
 移進去後點選xx.mlmodel查看訊息<br>
 <table>
  <tr>
    <td>Name</td>
    <td>Type</td>
    <td>Description</td>
  </tr>
  <tr>
    <td>Inputs(image)</td>
    <td>image(Color 64 X 64)</td>
    <td>64*64 image</td>
  </tr>
  <tr>
    <td>Outputs</td>
    <td>MultiArray(Double 11)</td>
    <td>'Apple Red 2, Apricot, Banana Lady Finger, Cantaloupe 1, Carambula,Cherry 2,Corn, Ginger Root, Strawberry Wedge,Tomato Cherry Red,Watermelon'</td>
    </tr>
</table>

然後再Model Class 點自己load model旁邊有個箭頭 點下去 Xcode會自動產生 Model Class<br>
這樣就大功告成了，接下來就是看自己如何用Swift調用model<br>
# 參考文獻
[1]https://github.com/keras-team/keras/issues/13364<br>
[2]https://stackoverflow.com/questions/58028976/typeerror-unexpected-keyword-argument-passed-to-optimizer-learning-rate<br>
[3]https://www.iowncode.com/ios-cat-and-dog-image-classifier-with-coreml-and-keras/
[4]https://apple.github.io/coremltools/generated/coremltools.converters.keras.convert.html
