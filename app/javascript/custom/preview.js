// document.addEventListener('DOMContentLoaded', () => {
//     const filesInput = document.getElementById('up_images');
//     const filePreviewList = document.getElementById('file-preview-list');
//
//     filesInput.addEventListener('change', (e) => {
//         filePreviewList.innerHTML = ''; // プレビューをクリア
//
//         for (const file of e.target.files) {
//             const reader = new FileReader();
//             const listItem = document.createElement('li');
//             const image = document.createElement('img');
//
//             reader.onload = (event) => {
//                 image.src = event.target.result;
//             };
//
//             reader.readAsDataURL(file);
//
//             listItem.appendChild(image);
//             filePreviewList.appendChild(listItem);
//         }
//     });
// });

document.addEventListener('DOMContentLoaded', () => {
    const filesInput = document.getElementById('up_images');
    const filePreviewList = document.getElementById('file-preview-list');

    filesInput.addEventListener('change', (e) => {
        filePreviewList.innerHTML = ''; // プレビューをクリア
        const maxFiles = 4; // 選択可能なファイルの最大数

        for (let i = 0; i < Math.min(e.target.files.length, maxFiles); i++) {
            const file = e.target.files[i];
            const reader = new FileReader();
            const listItem = document.createElement('li');
            const image = document.createElement('img');

            reader.onload = (event) => {
                image.src = event.target.result;
            };

            reader.readAsDataURL(file);

            listItem.appendChild(image);
            filePreviewList.appendChild(listItem);
        }

        if (e.target.files.length > maxFiles) {
            alert(`選択できるファイルは${maxFiles}枚までです。`);
            // ファイル選択をクリア
            filesInput.value = null;
        }
    });
});
