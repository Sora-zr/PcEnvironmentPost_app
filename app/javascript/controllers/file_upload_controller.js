import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="file-upload"
export default class extends Controller {
  // static targets = ['drop', 'preview']
  static targets = ["select", "preview", "image_box", "drop", "error"]

  connect() {
  }

  imageSizeOver(file){ // アップロードする画像ファイルサイズの上限（2MB）を超えたかどうか判定
    const fileSize = (file.size)/1000 // ファイルサイズ(KB)
    if(fileSize > 2000){
      return true // ファイルサイズが2MBを超えた場合はtrueを返す
    }else{
      return false
    }
  }

  dragover(e) {
    e.preventDefault()
    // dragover したときに drop_area の色を変える
    this.dropTarget.classList.remove('drop-default-color')
    this.dropTarget.classList.add('drop-color')
  }

  dragleave(e) {
    e.preventDefault()
    // dragleave したときに drop_area の色を元に戻す
    this.dropTarget.classList.remove("drop-color")
    this.dropTarget.classList.add("drop-default-color")
  }

  dropImages(e){
    e.preventDefault()
    // drop した後に drop_area の色を元に戻す
    this.dropTarget.classList.remove("drop-color")
    this.dropTarget.classList.add("drop-default-color")

    this.errorTarget.textContent = ""
    const uploadedFilesCount = this.previewTarget.querySelectorAll(".image-box").length
    const files = e.dataTransfer.files // ドラッグ&ドロップした画像ファイルを読み込む
    if(files.length + uploadedFilesCount > 8){
      this.errorTarget.textContent = "画像アップロード上限は最大8枚です。"
    }else{
      for(const file of files){
        if(this.imageSizeOver(file)){
          this.errorTarget.textContent = "ファイルサイズの上限(1枚あたり5MB)を超えている画像はアップロードできません。"
        }else{
          this.uploadImage(file) // ファイルのアップロード
        }
      }
    }
    this.selectTarget.value = "" // 選択ファイルのリセット
  }

  selectImages() {
    const files = this.selectTargets[0].files
    for(const file of files){
      this.uploadImage(file)
    }
    this.selectTarget.value = ''
  }

  uploadImage(file) {
    const csrfToken = document.getElementsByName('csrf-token')[0].content // CSRFトークンを取得
    const formData = new FormData()
    formData.append("image", file) // formDataオブジェクトに画像ファイルをセット
    const options = {
      method: 'POST',
      headers: {
        'X-CSRF-Token': csrfToken
      },
      body: formData
    }
    /* fetchで画像ファイルをPostコントローラー(upload_imageアクション)に送信 */
    fetch("/posts/upload_image", options)
        .then(response => response.json())
        .then(data => { // Postコントローラーからのレスポンス(blobデータ)
          this.previewImage(file, data.id) // 画像プレビューアクションにblobデータのidを受け渡す
        })
        .catch((error) => {
          console.error(error)
        })
  }

  previewImage(file, id){
    const preview = this.previewTarget // プレビュー表示用の<div>要素
    const fileReader = new FileReader()
    const setAttr = (element, obj)=>{ // 属性設定用の関数
      Object.keys(obj).forEach((key)=>{
        element.setAttribute(key, obj[key])
      })
    }
    fileReader.readAsDataURL(file) // ファイルをData URIとして読み込む
    fileReader.onload = (function () { // ファイル読み込み時の処理
      const img = new Image()
      const imgBox = document.createElement("div")
      const imgInnerBox = document.createElement("div")
      const deleteBtn = document.createElement("a")
      const hiddenField = document.createElement("input")
      const imgBoxAttr = { // imgBoxに設定する属性
        "class" : "",
        "data-controller" : "file-upload",
        "data-file-upload-target" : "image_box",
      }
      const imgInnerBoxAttr = { // imgInnerBoxに設定する属性
        "class" : "text-center card me-2"
      }
      const deleteBtnAttr = { // deleteBtnに設定する属性
        "class" : "preview-delete-btn",
        "data-action" : "click->file-upload#deleteImage"
      }
      const hiddenFieldAttr = { // hiddenFieldに設定する属性
        "name" : "post[images][]",
        "style" : "none",
        "type" : "hidden",
        "value" : id, // 受け取ったidをセット
      }
      setAttr(imgBox, imgBoxAttr)
      setAttr(imgInnerBox, imgInnerBoxAttr)
      setAttr(deleteBtn, deleteBtnAttr)
      setAttr(hiddenField, hiddenFieldAttr)

      deleteBtn.textContent = "削除"

      imgBox.appendChild(imgInnerBox)
      imgInnerBox.appendChild(img)
      imgInnerBox.appendChild(deleteBtn)
      imgInnerBox.appendChild(hiddenField)
      img.src = this.result
      img.width = 250;
      img.height = 150;
      img.style.objectFit = "contain";

      preview.appendChild(imgBox) // プレビュー表示用の<div>要素の中にimgBox（プレビュー画像の要素）を入れる
    })
  }

  deleteImage(){
    this.image_boxTarget.remove()
  }
}
