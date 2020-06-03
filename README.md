# Keras-model-to-Ios

# Mac(只能用Mac把Keras model to CoreML model)
要注意windwon是不能轉的因為pip install coremltools==3.0b6載不到，用別版也是轉失敗
下載Anaconda Navigator python 2.7版
因為CoreML不支援python3最多支援2.7
下載完後開啟 Anaconda terminal
安裝tensorflow 1.13.1 keras 2.2.4 & 2.3.1 coremltools 3.0b6

    python2 -m pip install --upgrade pip
    python2 -m pip install --upgrade https://storage.googleapis.com/tensorflow/mac/cpu/tensorflow-1.13.1-py2-none-any.whl
    pip install -U coremltools==3.0b6 keras==2.2.4
    
這邊keras 網路上查是說用2.2.4，但後轉換成CoreML model的時候出現錯誤
TypeError: Unexpected keyword argument passed to optimizer: learning_rate
當初用compile = False能轉成供但在xcode調用model會有問題，後來更新至2.3.1就解決了...這邊坑蠻大的如果有出現這問題請升級keras
https://github.com/keras-team/keras/issues/13364
https://stackoverflow.com/questions/58028976/typeerror-unexpected-keyword-argument-passed-to-optimizer-learning-rate
# keras model to CoreML model code
    import coremltools
    from keras.models import load_model
    model = load_model('cnn_model1.h5')
    coreml_model = coremltools.converters.keras.convert(model, input_names=['image'], output_names=['output'],image_input_names='image')
    coreml_model.author = 'jed'
    coreml_model.short_description = 'furit'
    coreml_model.input_description['image'] = '64*64 image'
    coreml_model.output_description['output'] = 'Apple Red 2, Apricot, Banana Lady Finger, Cantaloupe 1, Carambula,Cherry 2,Corn, Ginger   Root, Strawberry Wedge,Tomato Cherry Red,Watermelon'
    coreml_model.save('xx.mlmodel')
 如果轉換成功後會多一個xx.mlmodel檔案
 
 # xocde use mlmodel
 開啟Xcode 把xx.mlmodel移至Xcode專案裡面
 移進去後點選xx.mlmodel查看訊息
 可以看到Name Type Description
 Name 分別 Inputs output 
 Type 分別 Image(Color 64*64) 
 
 <table>
  <tr>
    <td>項次</td>
    <td>品名</td>
    <td>描述</td>
  </tr>
  <tr>
    <td>1</td>
    <td>iPhone 5</td>
    <td>iPhone 5是由蘋果公司開發的觸控式螢幕智慧型手機，是第六代的iPhone和繼承前一代的iPhone 4S。這款手機的設計比較以前產品更薄、更輕，及擁有更高解析度及更廣闊的4英寸觸控式螢幕，支援16:9寬螢幕。這款手機包括了一個自定義設計的ARMv7處理器的蘋果A6的更新、iOS 6操作系統，並且支援高速LTE網路。</td>
  </tr>
</table>
