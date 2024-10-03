import 'package:cached_network_image/cached_network_image.dart';
import 'package:da_administrator/model/questions/check_model.dart';
import 'package:da_administrator/model/questions/pg_model.dart';
import 'package:da_administrator/model/questions/stuffing_model.dart';
import 'package:da_administrator/model/questions/truefalse_model.dart';
import 'package:da_administrator/pages/detail_to_page.dart';
import 'package:da_administrator/pages/function_qustion/edit_questions.dart';
import 'package:da_administrator/pages/questions_page.dart';
import 'package:da_administrator/service/color.dart';
import 'package:da_administrator/service/component.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:vsc_quill_delta_to_html/vsc_quill_delta_to_html.dart';

Future<void> addMultiJawabanDialog() async {
  await showDialog(
    context: contextF!,
    builder: (BuildContext context) {
      bool showHeight = false;

      final QuillController soalController = QuillController.basic();
      final QuillController deskController = QuillController.basic();

      TextEditingController urlController = TextEditingController();
      List<TextEditingController> controllers = [TextEditingController()];
      List<String> trueAnswer = [' '];

      PlatformFile? pickedFileQuest;
      UploadTask? uploadTaskQuest;

      List<String> images = [''];
      int jmlImage = 1;

      bool onUploadQuest = false;

      bool onUpload = false;

      Future<void> selectedImageQuest() async {
        final result = await FilePicker.platform.pickFiles(type: FileType.image);
        if (result == null) return;
        pickedFileQuest = result.files.first;
      }

      Future<void> uploadImageQuest(int index) async {
        final bytes = pickedFileQuest!.bytes!;
        final ref = FirebaseStorage.instance.ref().child('question_${tryout!.toName}/${pickedFileQuest?.name}');
        uploadTaskQuest = ref.putData(bytes);

        final snapshot = await uploadTaskQuest!.whenComplete(() {});
        final urlDownload = await snapshot.ref.getDownloadURL();
        images[index] = urlDownload;
      }

      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          Widget jawaban(int index) {
            bool answerSelected = trueAnswer[index] == controllers[index].text;

            PlatformFile? pickedFile;
            UploadTask? uploadTask;

            Future<void> selectedImage() async {
              final result = await FilePicker.platform.pickFiles(type: FileType.image);
              if (result == null) return;
              setState(() => pickedFile = result.files.first);
            }

            Future<void> uploadImage(int index) async {
              final bytes = pickedFile!.bytes!;
              final ref = FirebaseStorage.instance.ref().child('question_${tryout!.toName}/${pickedFile?.name}');
              uploadTask = ref.putData(bytes);

              final snapshot = await uploadTask!.whenComplete(() {});
              final urlDownload = await snapshot.ref.getDownloadURL();
              controllers[index] = TextEditingController(text: urlDownload);
              setState(() {});
            }

            return Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 10, 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: isUrl(controllers[index].text)
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              imageUrl: controllers[index].text,
                              fit: BoxFit.fitWidth,
                              placeholder: (context, url) => Center(child: CircularProgressIndicator(color: primary)),
                              errorWidget: (context, url, error) => const Icon(Icons.error),
                            ),
                          )
                        : SizedBox(
                            height: 40,
                            child: TextFormField(
                              controller: controllers[index],
                              style: TextStyle(color: Colors.black, fontSize: h4),
                              maxLines: 1,
                              decoration: InputDecoration(
                                label: Text('Jawaban', style: TextStyle(color: Colors.black, fontSize: h4)),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.black)),
                              ),
                            ),
                          ),
                  ),
                  (onUpload)
                      ? Container(height: 40, width: 40, padding: const EdgeInsets.all(5), child: const CircularProgressIndicator())
                      : IconButton(
                          onPressed: () async {
                            try {
                              setState(() => onUpload = !onUpload);
                              await selectedImage();
                              if (pickedFile != null) {
                                await uploadImage(index);
                              }
                              pickedFile = null;
                              setState(() => onUpload = !onUpload);
                            } catch (e) {
                              print('salah ni $e');
                            }
                          },
                          icon: const Icon(Icons.image, color: Colors.black),
                        ),
                  if (controllers.length > 1)
                    IconButton(
                      onPressed: () => setState(() {
                        controllers.removeAt(index);
                        trueAnswer.removeAt(index);
                      }),
                      icon: const Icon(Icons.delete, color: Colors.black),
                    ),
                  IconButton(
                    onPressed: () {
                      if (controllers[index].text.isNotEmpty) {
                        if (answerSelected) {
                          setState(() => trueAnswer[index] = ' ');
                        } else {
                          setState(() => trueAnswer[index] = controllers[index].text);
                        }
                      }
                    },
                    icon: Icon(answerSelected ? Icons.check_box : Icons.check_box_outline_blank_rounded, color: answerSelected ? primary : Colors.black),
                  ),
                ],
              ),
            );
          }

          return AlertDialog(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            title: Row(
              children: [
                Text('Masukkan Soal ', style: TextStyle(color: Colors.black, fontSize: h4, fontWeight: FontWeight.normal)),
                Container(
                  decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(50)),
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: Text('Banyak Pilihan', style: TextStyle(color: Colors.white, fontSize: h4, fontWeight: FontWeight.normal)),
                ),
              ],
            ),
            contentPadding: const EdgeInsets.all(5),
            content: SizedBox(
              width: 1300,
              child: SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Container(
                              height: 600,
                              decoration: BoxDecoration(color: secondaryWhite, borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 30,
                                    margin: const EdgeInsets.fromLTRB(10, 10, 5, 0),
                                    child: OutlinedButton.icon(
                                      onPressed: () => setState(() {
                                        jmlImage++;
                                        images.add('');
                                      }),
                                      icon: const Icon(Icons.add, color: Colors.black),
                                      label: Text('Tambah Soal Gambar', style: TextStyle(color: Colors.black, fontSize: h4)),
                                    ),
                                  ),
                                  Row(
                                    children: List.generate(
                                      jmlImage,
                                      (index) {
                                        return Container(
                                          width: 100,
                                          height: 200,
                                          margin: const EdgeInsets.fromLTRB(10, 10, 5, 0),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              ClipRRect(
                                                borderRadius: BorderRadius.circular(10),
                                                child: Container(
                                                  color: Colors.white,
                                                  child: AspectRatio(
                                                    aspectRatio: 3 / 4,
                                                    child: images[index] != ''
                                                        ? CachedNetworkImage(
                                                            imageUrl: images[index],
                                                            fit: BoxFit.cover,
                                                            placeholder: (context, url) => Center(child: CircularProgressIndicator(color: primary)),
                                                            errorWidget: (context, url, error) => const Icon(Icons.error),
                                                          )
                                                        : const Icon(Icons.image, color: Colors.grey),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 30,
                                                width: double.infinity,
                                                child: OutlinedButton(
                                                  onPressed: () async {
                                                    try {
                                                      setState(() => onUploadQuest = !onUploadQuest);
                                                      await selectedImageQuest();
                                                      if (pickedFileQuest != null) {
                                                        await uploadImageQuest(index);
                                                      }
                                                      pickedFileQuest = null;
                                                      setState(() => onUploadQuest = !onUploadQuest);
                                                    } catch (e) {
                                                      print('salah ni $e');
                                                    }
                                                    setState(() {});
                                                  },
                                                  style: OutlinedButton.styleFrom(padding: EdgeInsets.zero),
                                                  child: Text(images[index] != '' ? 'Edit' : 'Tambah', style: TextStyle(color: Colors.black, fontSize: h4)),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 30,
                                                width: double.infinity,
                                                child: OutlinedButton(
                                                  onPressed: () => setState(() {
                                                    jmlImage--;
                                                    images.removeAt(index);
                                                  }),
                                                  style: OutlinedButton.styleFrom(padding: EdgeInsets.zero),
                                                  child: Text('Hapus', style: TextStyle(color: Colors.black, fontSize: h4)),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  QuillToolbar.simple(
                                    configurations: QuillSimpleToolbarConfigurations(
                                      controller: soalController,
                                      color: Colors.black,
                                      sharedConfigurations: const QuillSharedConfigurations(locale: Locale('id')),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      margin: const EdgeInsets.all(10),
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                                      child: QuillEditor.basic(
                                        configurations: QuillEditorConfigurations(
                                          controller: soalController,
                                          placeholder: 'Soal',
                                          customStyleBuilder: (attribute) => TextStyle(color: Colors.black, fontSize: h4),
                                          checkBoxReadOnly: false,
                                          sharedConfigurations: const QuillSharedConfigurations(locale: Locale('id')),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Column(children: List.generate(controllers.length, (index) => jawaban(index))),
                      SizedBox(
                        height: 40,
                        child: TextFormField(
                          controller: urlController,
                          style: TextStyle(color: Colors.black, fontSize: h4),
                          maxLines: 1,
                          decoration: InputDecoration(
                            labelText: 'Url video Penjelasan',
                            labelStyle: TextStyle(color: Colors.black, fontSize: h4),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.black)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(color: secondaryWhite, borderRadius: BorderRadius.circular(10)),
                        height: 400,
                        child: Column(
                          children: [
                            QuillToolbar.simple(
                              configurations: QuillSimpleToolbarConfigurations(
                                controller: deskController,
                                color: Colors.black,
                                sharedConfigurations: const QuillSharedConfigurations(locale: Locale('id')),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.all(10),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                                child: QuillEditor.basic(
                                  configurations: QuillEditorConfigurations(
                                    placeholder: 'Deskripsi Jawaban',
                                    customStyleBuilder: (attribute) => TextStyle(color: Colors.black, fontSize: h4),
                                    controller: deskController,
                                    checkBoxReadOnly: false,
                                    sharedConfigurations: const QuillSharedConfigurations(locale: Locale('id')),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actionsPadding: const EdgeInsets.all(10),
            actions: [
              Row(
                children: [
                  Expanded(
                    child: AnimatedContainer(
                      margin: const EdgeInsets.only(bottom: 10),
                      duration: const Duration(milliseconds: 300),
                      height: showHeight ? 40 : 0,
                      decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(50)),
                      alignment: Alignment.center,
                      child: Wrap(children: [Text('lengkapi form terlebih dahulu', style: TextStyle(color: Colors.white, fontSize: h4, fontWeight: FontWeight.bold))]),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: () => setState(() {
                      trueAnswer.add(' ');
                      controllers.add(TextEditingController());
                    }),
                    label: Text('Tambah Jawaban', style: TextStyle(color: Colors.black, fontSize: h4)),
                    icon: const Icon(Icons.add, color: Colors.black),
                  ),
                  const Expanded(child: SizedBox()),
                  TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('Batal', style: TextStyle(color: Colors.black, fontSize: h4))),
                  TextButton(
                    onPressed: () async {
                      List<String> options = [];
                      options.addAll(controllers.map((controller) => controller.text));
                      if (soalController.document.toDelta().isNotEmpty && options.isNotEmpty) {
                        final converterSoal = QuillDeltaToHtmlConverter(soalController.document.toDelta().toJson(), ConverterOptions.forEmail());
                        final converterDesk = QuillDeltaToHtmlConverter(deskController.document.toDelta().toJson(), ConverterOptions.forEmail());

                        final htmlSoal = converterSoal.convert();
                        final htmlDesk = converterDesk.convert();

                        question!.listQuestions.add(
                          CheckModel(
                            question: htmlSoal,
                            options: options,
                            trueAnswer: trueAnswer,
                            type: 'banyak_pilihan',
                            yourAnswer: [],
                            image: images,
                            value: null,
                            rating: 0,
                            urlVideoExplanation: urlController.text,
                            explanation: htmlDesk,
                          ),
                        );

                        Navigator.of(context).pop();
                      } else {
                        setState(() => showHeight = !showHeight);
                        await Future.delayed(const Duration(seconds: 1));
                        setState(() => showHeight = !showHeight);
                      }
                    },
                    child: Text('Selesai', style: TextStyle(color: Colors.black, fontSize: h4)),
                  ),
                ],
              )
            ],
          );
        },
      );
    },
  );
}

Future<void> addPGDialog() async {
  String? trueAnswer;
  await showDialog(
    context: contextF!,
    builder: (BuildContext context) {
      bool showHeight = false;

      final QuillController soalController = QuillController.basic();
      final QuillController deskController = QuillController.basic();

      TextEditingController urlController = TextEditingController();

      List<TextEditingController> controllers = [TextEditingController()];

      PlatformFile? pickedFileQuest;
      UploadTask? uploadTaskQuest;

      List<String> images = [''];
      int jmlImage = 1;

      Future<void> selectedImageQuest() async {
        final result = await FilePicker.platform.pickFiles(type: FileType.image);
        if (result == null) return;
        pickedFileQuest = result.files.first;
      }

      Future<void> uploadImageQuest(int index) async {
        final bytes = pickedFileQuest!.bytes!;
        final ref = FirebaseStorage.instance.ref().child('question_${tryout!.toName}/${pickedFileQuest?.name}');
        uploadTaskQuest = ref.putData(bytes);

        final snapshot = await uploadTaskQuest!.whenComplete(() {});
        final urlDownload = await snapshot.ref.getDownloadURL();
        images[index] = urlDownload;
      }

      bool onUploadQuest = false;

      bool onUpload = false;

      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          Widget jawaban(int index) {
            bool answerSelected = trueAnswer == controllers[index].text;
            PlatformFile? pickedFile;
            UploadTask? uploadTask;

            Future<void> selectedImage() async {
              final result = await FilePicker.platform.pickFiles(type: FileType.image);
              if (result == null) return;
              setState(() => pickedFile = result.files.first);
            }

            Future<void> uploadImage(int index) async {
              final bytes = pickedFile!.bytes!;
              final ref = FirebaseStorage.instance.ref().child('question_${tryout!.toName}/${pickedFile?.name}');
              uploadTask = ref.putData(bytes);

              final snapshot = await uploadTask!.whenComplete(() {});
              final urlDownload = await snapshot.ref.getDownloadURL();
              controllers[index] = TextEditingController(text: urlDownload);
              setState(() {});
            }

            return Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 10, 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: isUrl(controllers[index].text)
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              imageUrl: controllers[index].text,
                              fit: BoxFit.fitWidth,
                              placeholder: (context, url) => Center(child: CircularProgressIndicator(color: primary)),
                              errorWidget: (context, url, error) => const Icon(Icons.error),
                            ),
                          )
                        : SizedBox(
                            height: 40,
                            child: TextFormField(
                              controller: controllers[index],
                              style: TextStyle(color: Colors.black, fontSize: h4),
                              maxLines: 1,
                              decoration: InputDecoration(
                                label: Text('Jawaban', style: TextStyle(color: Colors.black, fontSize: h4)),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.black)),
                              ),
                            ),
                          ),
                  ),
                  (onUpload)
                      ? Container(height: 40, width: 40, padding: const EdgeInsets.all(5), child: const CircularProgressIndicator())
                      : IconButton(
                          onPressed: () async {
                            try {
                              setState(() => onUpload = !onUpload);
                              await selectedImage();
                              if (pickedFile != null) {
                                await uploadImage(index);
                              }
                              pickedFile = null;
                              setState(() => onUpload = !onUpload);
                            } catch (e) {
                              print('salah ni $e');
                            }
                          },
                          icon: const Icon(Icons.image, color: Colors.black),
                        ),
                  if (controllers.length > 1)
                    IconButton(
                      onPressed: () => setState(() => controllers.removeAt(index)),
                      icon: const Icon(Icons.delete, color: Colors.black),
                    ),
                  IconButton(
                    onPressed: () {
                      if (controllers[index].text.isNotEmpty) {
                        setState(() => trueAnswer = controllers[index].text);
                      }
                    },
                    icon: Icon(answerSelected ? Icons.check_circle : Icons.cancel, color: answerSelected ? primary : secondary),
                  ),
                ],
              ),
            );
          }

          return AlertDialog(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            title: Row(
              children: [
                Text('Masukkan Soal ', style: TextStyle(color: Colors.black, fontSize: h4, fontWeight: FontWeight.normal)),
                Container(
                  decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(50)),
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: Text('Pilihan Ganda', style: TextStyle(color: Colors.white, fontSize: h4, fontWeight: FontWeight.normal)),
                ),
              ],
            ),
            contentPadding: const EdgeInsets.all(5),
            content: SizedBox(
              width: 1300,
              child: SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Container(
                        height: 600,
                        decoration: BoxDecoration(color: secondaryWhite, borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 30,
                              margin: const EdgeInsets.fromLTRB(10, 10, 5, 0),
                              child: OutlinedButton.icon(
                                onPressed: () => setState(() {
                                  jmlImage++;
                                  images.add('');
                                }),
                                icon: const Icon(Icons.add, color: Colors.black),
                                label: Text('Tambah Soal Gambar', style: TextStyle(color: Colors.black, fontSize: h4)),
                              ),
                            ),
                            Row(
                              children: List.generate(
                                jmlImage,
                                (index) {
                                  return Container(
                                    width: 100,
                                    height: 200,
                                    margin: const EdgeInsets.fromLTRB(10, 10, 5, 0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          child: Container(
                                            color: Colors.white,
                                            child: AspectRatio(
                                              aspectRatio: 3 / 4,
                                              child: images[index] != ''
                                                  ? CachedNetworkImage(
                                                      imageUrl: images[index],
                                                      fit: BoxFit.cover,
                                                      placeholder: (context, url) => Center(child: CircularProgressIndicator(color: primary)),
                                                      errorWidget: (context, url, error) => const Icon(Icons.error),
                                                    )
                                                  : const Icon(Icons.image, color: Colors.grey),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 30,
                                          width: double.infinity,
                                          child: OutlinedButton(
                                            onPressed: () async {
                                              try {
                                                setState(() => onUploadQuest = !onUploadQuest);
                                                await selectedImageQuest();
                                                if (pickedFileQuest != null) {
                                                  await uploadImageQuest(index);
                                                }
                                                pickedFileQuest = null;
                                                setState(() => onUploadQuest = !onUploadQuest);
                                              } catch (e) {
                                                print('salah ni $e');
                                              }
                                              setState(() {});
                                            },
                                            style: OutlinedButton.styleFrom(padding: EdgeInsets.zero),
                                            child: Text(images[index] != '' ? 'Edit' : 'Tambah', style: TextStyle(color: Colors.black, fontSize: h4)),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 30,
                                          width: double.infinity,
                                          child: OutlinedButton(
                                            onPressed: () => setState(() {
                                              jmlImage--;
                                              images.removeAt(index);
                                            }),
                                            style: OutlinedButton.styleFrom(padding: EdgeInsets.zero),
                                            child: Text('Hapus', style: TextStyle(color: Colors.black, fontSize: h4)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                            QuillToolbar.simple(
                              configurations: QuillSimpleToolbarConfigurations(
                                controller: soalController,
                                color: Colors.black,
                                sharedConfigurations: const QuillSharedConfigurations(locale: Locale('id')),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.all(10),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                                child: QuillEditor.basic(
                                  configurations: QuillEditorConfigurations(
                                    controller: soalController,
                                    placeholder: 'Soal',
                                    customStyleBuilder: (attribute) => TextStyle(color: Colors.black, fontSize: h4),
                                    checkBoxReadOnly: false,
                                    sharedConfigurations: const QuillSharedConfigurations(locale: Locale('id')),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Column(children: List.generate(controllers.length, (index) => jawaban(index))),
                      SizedBox(
                        height: 40,
                        child: TextFormField(
                          controller: urlController,
                          style: TextStyle(color: Colors.black, fontSize: h4),
                          maxLines: 1,
                          decoration: InputDecoration(
                            labelText: 'Url video Penjelasan',
                            labelStyle: TextStyle(color: Colors.black, fontSize: h4),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.black)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(color: secondaryWhite, borderRadius: BorderRadius.circular(10)),
                        height: 400,
                        child: Column(
                          children: [
                            QuillToolbar.simple(
                              configurations: QuillSimpleToolbarConfigurations(
                                controller: deskController,
                                color: Colors.black,
                                sharedConfigurations: const QuillSharedConfigurations(locale: Locale('id')),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.all(10),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                                child: QuillEditor.basic(
                                  configurations: QuillEditorConfigurations(
                                    placeholder: 'Deskripsi Jawaban',
                                    customStyleBuilder: (attribute) => TextStyle(color: Colors.black, fontSize: h4),
                                    controller: deskController,
                                    checkBoxReadOnly: false,
                                    sharedConfigurations: const QuillSharedConfigurations(locale: Locale('id')),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actionsPadding: const EdgeInsets.all(10),
            actions: [
              Row(
                children: [
                  Expanded(
                    child: AnimatedContainer(
                      margin: const EdgeInsets.only(bottom: 10),
                      duration: const Duration(milliseconds: 300),
                      height: showHeight ? 40 : 0,
                      decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(50)),
                      alignment: Alignment.center,
                      child: Wrap(children: [Text('lengkapi form terlebih dahulu', style: TextStyle(color: Colors.white, fontSize: h4, fontWeight: FontWeight.bold))]),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: () => setState(() => controllers.add(TextEditingController())),
                    label: Text('Tambah Jawaban', style: TextStyle(color: Colors.black, fontSize: h4)),
                    icon: const Icon(Icons.add, color: Colors.black),
                  ),
                  const Expanded(child: SizedBox()),
                  TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('Batal', style: TextStyle(color: Colors.black, fontSize: h4))),
                  TextButton(
                    onPressed: () async {
                      List<String> options = [];
                      options.addAll(controllers.map((controller) => controller.text));
                      if (trueAnswer != null &&
                          soalController.document.toDelta().isNotEmpty &&
                          urlController.text.isNotEmpty &&
                          deskController.document.toDelta().isNotEmpty &&
                          options.isNotEmpty) {
                        final soalConverter = QuillDeltaToHtmlConverter(soalController.document.toDelta().toJson(), ConverterOptions.forEmail());
                        final deskConverter = QuillDeltaToHtmlConverter(deskController.document.toDelta().toJson(), ConverterOptions.forEmail());

                        final soalHtml = soalConverter.convert();
                        final deskHtml = deskConverter.convert();

                        question!.listQuestions.add(
                          PgModel(
                            question: soalHtml,
                            options: options,
                            trueAnswer: trueAnswer!,
                            type: 'pilihan_ganda',
                            yourAnswer: [],
                            image: images,
                            value: null,
                            rating: 0,
                            urlVideoExplanation: urlController.text,
                            explanation: deskHtml,
                          ),
                        );

                        Navigator.of(context).pop();
                      } else {
                        setState(() => showHeight = !showHeight);
                        await Future.delayed(const Duration(seconds: 1));
                        setState(() => showHeight = !showHeight);
                      }
                    },
                    child: Text('Selesai', style: TextStyle(color: Colors.black, fontSize: h4)),
                  ),
                ],
              )
            ],
          );
        },
      );
    },
  );
}

Future<void> addIsianDialog() async {
  await showDialog(
    context: contextF!,
    builder: (BuildContext context) {
      bool showHeight = false;

      final QuillController soalController = QuillController.basic();
      final QuillController deskController = QuillController.basic();

      TextEditingController urlController = TextEditingController();
      TextEditingController trueAnswerController = TextEditingController();

      PlatformFile? pickedFileQuest;
      UploadTask? uploadTaskQuest;

      List<String> images = [''];
      int jmlImage = 1;

      Future<void> selectedImageQuest() async {
        final result = await FilePicker.platform.pickFiles(type: FileType.image);
        if (result == null) return;
        pickedFileQuest = result.files.first;
      }

      Future<void> uploadImageQuest(int index) async {
        final bytes = pickedFileQuest!.bytes!;
        final ref = FirebaseStorage.instance.ref().child('question_${tryout!.toName}/${pickedFileQuest?.name}');
        uploadTaskQuest = ref.putData(bytes);

        final snapshot = await uploadTaskQuest!.whenComplete(() {});
        final urlDownload = await snapshot.ref.getDownloadURL();
        images[index] = urlDownload;
      }

      bool onUploadQuest = false;
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            title: Row(
              children: [
                Text('Masukkan Soal ', style: TextStyle(color: Colors.black, fontSize: h4, fontWeight: FontWeight.normal)),
                Container(
                  decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(50)),
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: Text('Isian', style: TextStyle(color: Colors.white, fontSize: h4, fontWeight: FontWeight.normal)),
                ),
              ],
            ),
            contentPadding: const EdgeInsets.all(5),
            content: SizedBox(
              width: 1300,
              child: SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Column(
                        children: [
                          Container(
                            height: 600,
                            decoration: BoxDecoration(color: secondaryWhite, borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 30,
                                  margin: const EdgeInsets.fromLTRB(10, 10, 5, 0),
                                  child: OutlinedButton.icon(
                                    onPressed: () => setState(() {
                                      jmlImage++;
                                      images.add('');
                                    }),
                                    icon: const Icon(Icons.add, color: Colors.black),
                                    label: Text('Tambah Soal Gambar', style: TextStyle(color: Colors.black, fontSize: h4)),
                                  ),
                                ),
                                Row(
                                  children: List.generate(
                                    jmlImage,
                                    (index) {
                                      return Container(
                                        width: 100,
                                        height: 200,
                                        margin: const EdgeInsets.fromLTRB(10, 10, 5, 0),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(10),
                                              child: Container(
                                                color: Colors.white,
                                                child: AspectRatio(
                                                  aspectRatio: 3 / 4,
                                                  child: images[index] != ''
                                                      ? CachedNetworkImage(
                                                          imageUrl: images[index],
                                                          fit: BoxFit.cover,
                                                          placeholder: (context, url) => Center(child: CircularProgressIndicator(color: primary)),
                                                          errorWidget: (context, url, error) => const Icon(Icons.error),
                                                        )
                                                      : const Icon(Icons.image, color: Colors.grey),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 30,
                                              width: double.infinity,
                                              child: OutlinedButton(
                                                onPressed: () async {
                                                  try {
                                                    setState(() => onUploadQuest = !onUploadQuest);
                                                    await selectedImageQuest();
                                                    if (pickedFileQuest != null) {
                                                      await uploadImageQuest(index);
                                                    }
                                                    pickedFileQuest = null;
                                                    setState(() => onUploadQuest = !onUploadQuest);
                                                  } catch (e) {
                                                    print('salah ni $e');
                                                  }
                                                  setState(() {});
                                                },
                                                style: OutlinedButton.styleFrom(padding: EdgeInsets.zero),
                                                child: Text(images[index] != '' ? 'Edit' : 'Tambah', style: TextStyle(color: Colors.black, fontSize: h4)),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 30,
                                              width: double.infinity,
                                              child: OutlinedButton(
                                                onPressed: () => setState(() {
                                                  jmlImage--;
                                                  images.removeAt(index);
                                                }),
                                                style: OutlinedButton.styleFrom(padding: EdgeInsets.zero),
                                                child: Text('Hapus', style: TextStyle(color: Colors.black, fontSize: h4)),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                QuillToolbar.simple(
                                  configurations: QuillSimpleToolbarConfigurations(
                                    controller: soalController,
                                    color: Colors.black,
                                    sharedConfigurations: const QuillSharedConfigurations(locale: Locale('id')),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    margin: const EdgeInsets.all(10),
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                                    child: QuillEditor.basic(
                                      configurations: QuillEditorConfigurations(
                                        placeholder: 'Soal',
                                        customStyleBuilder: (attribute) => TextStyle(color: Colors.black, fontSize: h4),
                                        controller: soalController,
                                        checkBoxReadOnly: false,
                                        sharedConfigurations: const QuillSharedConfigurations(locale: Locale('id')),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 40,
                        child: TextFormField(
                          controller: trueAnswerController,
                          style: TextStyle(color: Colors.black, fontSize: h4),
                          maxLines: 1,
                          decoration: InputDecoration(
                            label: Text('Jawaban', style: TextStyle(color: Colors.black, fontSize: h4)),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.black)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 40,
                        child: TextFormField(
                          controller: urlController,
                          style: TextStyle(color: Colors.black, fontSize: h4),
                          maxLines: 1,
                          decoration: InputDecoration(
                            labelText: 'Url video Penjelasan',
                            labelStyle: TextStyle(color: Colors.black, fontSize: h4),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.black)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(color: secondaryWhite, borderRadius: BorderRadius.circular(10)),
                        height: 400,
                        child: Column(
                          children: [
                            QuillToolbar.simple(
                              configurations: QuillSimpleToolbarConfigurations(
                                controller: deskController,
                                color: Colors.black,
                                sharedConfigurations: const QuillSharedConfigurations(locale: Locale('id')),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.all(10),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                                child: QuillEditor.basic(
                                  configurations: QuillEditorConfigurations(
                                    placeholder: 'Deskripsi Jawaban',
                                    customStyleBuilder: (attribute) => TextStyle(color: Colors.black, fontSize: h4),
                                    controller: deskController,
                                    checkBoxReadOnly: false,
                                    sharedConfigurations: const QuillSharedConfigurations(locale: Locale('id')),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actionsPadding: const EdgeInsets.all(10),
            actions: [
              Row(
                children: [
                  Expanded(
                    child: AnimatedContainer(
                      margin: const EdgeInsets.only(bottom: 10),
                      duration: const Duration(milliseconds: 300),
                      height: showHeight ? 40 : 0,
                      decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(50)),
                      alignment: Alignment.center,
                      child: Wrap(children: [Text('lengkapi form terlebih dahulu', style: TextStyle(color: Colors.white, fontSize: h4, fontWeight: FontWeight.bold))]),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('Batal', style: TextStyle(color: Colors.black, fontSize: h4))),
                  TextButton(
                    onPressed: () async {
                      if (trueAnswerController.text.isNotEmpty &&
                          soalController.document.toDelta().isNotEmpty &&
                          urlController.text.isNotEmpty &&
                          deskController.document.toDelta().isNotEmpty) {
                        final soalConverter = QuillDeltaToHtmlConverter(soalController.document.toDelta().toJson(), ConverterOptions.forEmail());
                        final deskConverter = QuillDeltaToHtmlConverter(deskController.document.toDelta().toJson(), ConverterOptions.forEmail());

                        final soalHtml = soalConverter.convert();
                        final deskHtml = deskConverter.convert();

                        question!.listQuestions.add(StuffingModel(
                          question: soalHtml,
                          trueAnswer: trueAnswerController.text,
                          type: 'isian',
                          yourAnswer: [],
                          image: images,
                          value: null,
                          rating: null,
                          urlVideoExplanation: urlController.text,
                          explanation: deskHtml,
                        ));

                        setState(() {});
                        Navigator.of(context).pop();
                      } else {
                        setState(() => showHeight = !showHeight);
                        await Future.delayed(const Duration(seconds: 1));
                        setState(() => showHeight = !showHeight);
                      }
                    },
                    child: Text('Selesai', style: TextStyle(color: Colors.black, fontSize: h4)),
                  ),
                ],
              ),
            ],
          );
        },
      );
    },
  );
}

Future<void> addBenarSalahDialog() async {
  await showDialog(
    context: contextF!,
    builder: (BuildContext context) {
      bool showHeight = false;

      final QuillController soalController = QuillController.basic();
      final QuillController deskController = QuillController.basic();

      TextEditingController urlController = TextEditingController();

      List<bool> trueAnswer = [false];
      List<TextEditingController> controllers = [TextEditingController()];

      PlatformFile? pickedFileQuest;
      UploadTask? uploadTaskQuest;

      List<String> images = [''];
      int jmlImage = 1;

      Future<void> selectedImageQuest() async {
        final result = await FilePicker.platform.pickFiles(type: FileType.image);
        if (result == null) return;
        pickedFileQuest = result.files.first;
      }

      Future<void> uploadImageQuest(int index) async {
        final bytes = pickedFileQuest!.bytes!;
        final ref = FirebaseStorage.instance.ref().child('question_${tryout!.toName}/${pickedFileQuest?.name}');
        uploadTaskQuest = ref.putData(bytes);

        final snapshot = await uploadTaskQuest!.whenComplete(() {});
        final urlDownload = await snapshot.ref.getDownloadURL();
        images[index] = urlDownload;
      }

      bool onUploadQuest = false;

      bool onUpload = false;

      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          Widget jawaban(int index) {
            PlatformFile? pickedFile;
            UploadTask? uploadTask;

            Future<void> selectedImage() async {
              final result = await FilePicker.platform.pickFiles(type: FileType.image);
              if (result == null) return;
              setState(() => pickedFile = result.files.first);
            }

            Future<void> uploadImage(int index) async {
              final bytes = pickedFile!.bytes!;
              final ref = FirebaseStorage.instance.ref().child('question_${tryout!.toName}/${pickedFile?.name}');
              uploadTask = ref.putData(bytes);

              final snapshot = await uploadTask!.whenComplete(() {});
              final urlDownload = await snapshot.ref.getDownloadURL();
              controllers[index] = TextEditingController(text: urlDownload);
              setState(() {});
            }

            return Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 10, 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: isUrl(controllers[index].text)
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              imageUrl: controllers[index].text,
                              fit: BoxFit.fitWidth,
                              placeholder: (context, url) => Center(child: CircularProgressIndicator(color: primary)),
                              errorWidget: (context, url, error) => const Icon(Icons.error),
                            ),
                          )
                        : SizedBox(
                            height: 40,
                            child: TextFormField(
                              controller: controllers[index],
                              style: TextStyle(color: Colors.black, fontSize: h4),
                              maxLines: 1,
                              decoration: InputDecoration(
                                label: Text('Jawaban', style: TextStyle(color: Colors.black, fontSize: h4)),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.black)),
                              ),
                            ),
                          ),
                  ),
                  (onUpload)
                      ? Container(height: 40, width: 40, padding: const EdgeInsets.all(5), child: const CircularProgressIndicator())
                      : IconButton(
                          onPressed: () async {
                            try {
                              setState(() => onUpload = !onUpload);
                              await selectedImage();
                              if (pickedFile != null) {
                                await uploadImage(index);
                              }
                              pickedFile = null;
                              setState(() => onUpload = !onUpload);
                            } catch (e) {
                              print('salah ni $e');
                            }
                          },
                          icon: const Icon(Icons.image, color: Colors.black),
                        ),
                  if (controllers.length > 1)
                    IconButton(
                      onPressed: () => setState(() {
                        controllers.removeAt(index);
                        trueAnswer.removeAt(index);
                      }),
                      icon: const Icon(Icons.delete, color: Colors.black),
                    ),
                  const SizedBox(width: 10),
                  TextButton(
                    style: TextButton.styleFrom(backgroundColor: trueAnswer[index] ? primary : secondary),
                    onPressed: () {
                      if (controllers[index].text.isNotEmpty) {
                        setState(() => trueAnswer[index] = !(trueAnswer[index]));
                      }
                    },
                    child: Text(trueAnswer[index] ? 'Benar' : 'Salah', style: TextStyle(color: Colors.white, fontSize: h4, fontWeight: FontWeight.normal)),
                  ),
                ],
              ),
            );
          }

          return AlertDialog(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            title: Row(
              children: [
                Text('Masukkan Soal ', style: TextStyle(color: Colors.black, fontSize: h4, fontWeight: FontWeight.normal)),
                Container(
                  decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(50)),
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: Text('Benar Salah', style: TextStyle(color: Colors.white, fontSize: h4, fontWeight: FontWeight.normal)),
                ),
              ],
            ),
            contentPadding: const EdgeInsets.all(5),
            content: SizedBox(
              width: 1300,
              child: SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Container(
                        height: 600,
                        decoration: BoxDecoration(color: secondaryWhite, borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 30,
                              margin: const EdgeInsets.fromLTRB(10, 10, 5, 0),
                              child: OutlinedButton.icon(
                                onPressed: () => setState(() {
                                  jmlImage++;
                                  images.add('');
                                }),
                                icon: const Icon(Icons.add, color: Colors.black),
                                label: Text('Tambah Soal Gambar', style: TextStyle(color: Colors.black, fontSize: h4)),
                              ),
                            ),
                            Row(
                              children: List.generate(
                                jmlImage,
                                (index) {
                                  return Container(
                                    width: 100,
                                    height: 200,
                                    margin: const EdgeInsets.fromLTRB(10, 10, 5, 0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          child: Container(
                                            color: Colors.white,
                                            child: AspectRatio(
                                              aspectRatio: 3 / 4,
                                              child: images[index] != ''
                                                  ? CachedNetworkImage(
                                                      imageUrl: images[index],
                                                      fit: BoxFit.cover,
                                                      placeholder: (context, url) => Center(child: CircularProgressIndicator(color: primary)),
                                                      errorWidget: (context, url, error) => const Icon(Icons.error),
                                                    )
                                                  : const Icon(Icons.image, color: Colors.grey),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 30,
                                          width: double.infinity,
                                          child: OutlinedButton(
                                            onPressed: () async {
                                              try {
                                                setState(() => onUploadQuest = !onUploadQuest);
                                                await selectedImageQuest();
                                                if (pickedFileQuest != null) {
                                                  await uploadImageQuest(index);
                                                }
                                                pickedFileQuest = null;
                                                setState(() => onUploadQuest = !onUploadQuest);
                                              } catch (e) {
                                                print('salah ni $e');
                                              }
                                              setState(() {});
                                            },
                                            style: OutlinedButton.styleFrom(padding: EdgeInsets.zero),
                                            child: Text(images[index] != '' ? 'Edit' : 'Tambah', style: TextStyle(color: Colors.black, fontSize: h4)),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 30,
                                          width: double.infinity,
                                          child: OutlinedButton(
                                            onPressed: () => setState(() {
                                              jmlImage--;
                                              images.removeAt(index);
                                            }),
                                            style: OutlinedButton.styleFrom(padding: EdgeInsets.zero),
                                            child: Text('Hapus', style: TextStyle(color: Colors.black, fontSize: h4)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                            QuillToolbar.simple(
                              configurations: QuillSimpleToolbarConfigurations(
                                controller: soalController,
                                color: Colors.black,
                                sharedConfigurations: const QuillSharedConfigurations(locale: Locale('id')),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.all(10),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                                child: QuillEditor.basic(
                                  configurations: QuillEditorConfigurations(
                                    controller: soalController,
                                    placeholder: 'Soal',
                                    customStyleBuilder: (attribute) => TextStyle(color: Colors.black, fontSize: h4),
                                    checkBoxReadOnly: false,
                                    sharedConfigurations: const QuillSharedConfigurations(locale: Locale('id')),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Column(children: List.generate(trueAnswer.length, (index) => jawaban(index))),
                      SizedBox(
                        height: 40,
                        child: TextFormField(
                          controller: urlController,
                          style: TextStyle(color: Colors.black, fontSize: h4),
                          maxLines: 1,
                          decoration: InputDecoration(
                            labelText: 'Url video Penjelasan',
                            labelStyle: TextStyle(color: Colors.black, fontSize: h4),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.black)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(color: secondaryWhite, borderRadius: BorderRadius.circular(10)),
                        height: 400,
                        child: Column(
                          children: [
                            QuillToolbar.simple(
                              configurations: QuillSimpleToolbarConfigurations(
                                controller: deskController,
                                color: Colors.black,
                                sharedConfigurations: const QuillSharedConfigurations(locale: Locale('id')),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.all(10),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                                child: QuillEditor.basic(
                                  configurations: QuillEditorConfigurations(
                                    placeholder: 'Deskripsi Jawaban',
                                    customStyleBuilder: (attribute) => TextStyle(color: Colors.black, fontSize: h4),
                                    controller: deskController,
                                    checkBoxReadOnly: false,
                                    sharedConfigurations: const QuillSharedConfigurations(locale: Locale('id')),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actionsPadding: const EdgeInsets.all(10),
            actions: [
              Row(
                children: [
                  Expanded(
                    child: AnimatedContainer(
                      margin: const EdgeInsets.only(bottom: 10),
                      duration: const Duration(milliseconds: 300),
                      height: showHeight ? 40 : 0,
                      decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(50)),
                      alignment: Alignment.center,
                      child: Wrap(children: [Text('lengkapi form terlebih dahulu', style: TextStyle(color: Colors.white, fontSize: h4, fontWeight: FontWeight.bold))]),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: () => setState(() {
                      trueAnswer.add(false);
                      controllers.add(TextEditingController());
                    }),
                    label: Text('Tambah Jawaban', style: TextStyle(color: Colors.black, fontSize: h4)),
                    icon: const Icon(Icons.add, color: Colors.black),
                  ),
                  const Expanded(child: SizedBox()),
                  TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('Batal', style: TextStyle(color: Colors.black, fontSize: h4))),
                  TextButton(
                    onPressed: () async {
                      final List<TrueFalseOption> options = List.generate(
                        trueAnswer.length,
                        (index) => TrueFalseOption(option: controllers[index].text, trueAnswer: trueAnswer[index]),
                      );
                      if (soalController.document.toDelta().isNotEmpty && urlController.text.isNotEmpty && deskController.document.toDelta().isNotEmpty && options.isNotEmpty) {
                        final soalConverter = QuillDeltaToHtmlConverter(soalController.document.toDelta().toJson(), ConverterOptions.forEmail());
                        final deskConverter = QuillDeltaToHtmlConverter(deskController.document.toDelta().toJson(), ConverterOptions.forEmail());

                        final soalHtml = soalConverter.convert();
                        final deskHtml = deskConverter.convert();
                        question!.listQuestions.add(
                          TrueFalseModel(
                            question: soalHtml,
                            trueAnswer: options,
                            type: 'benar_salah',
                            yourAnswer: [],
                            image: images,
                            value: null,
                            rating: 0,
                            urlVideoExplanation: urlController.text,
                            explanation: deskHtml,
                          ),
                        );

                        Navigator.of(context).pop();
                      } else {
                        setState(() => showHeight = !showHeight);
                        await Future.delayed(const Duration(seconds: 1));
                        setState(() => showHeight = !showHeight);
                      }
                    },
                    child: Text('Selesai', style: TextStyle(color: Colors.black, fontSize: h4)),
                  ),
                ],
              )
            ],
          );
        },
      );
    },
  );
}

//----------------------------------------------------------------
Future<void> addMultiJawabanDialogSmallDevice() async {
  await showDialog(
    context: contextF!,
    builder: (BuildContext context) {
      bool showHeight = false;

      final QuillController soalController = QuillController.basic();
      final QuillController deskController = QuillController.basic();

      TextEditingController urlController = TextEditingController();

      List<TextEditingController> controllers = [TextEditingController()];
      List<String> trueAnswer = [' '];

      PlatformFile? pickedFileQuest;
      UploadTask? uploadTaskQuest;

      List<String> images = [''];
      int jmlImage = 1;

      Future<void> selectedImageQuest() async {
        final result = await FilePicker.platform.pickFiles(type: FileType.image);
        if (result == null) return;
        pickedFileQuest = result.files.first;
      }

      Future<void> uploadImageQuest(int index) async {
        final bytes = pickedFileQuest!.bytes!;
        final ref = FirebaseStorage.instance.ref().child('question_${tryout!.toName}/${pickedFileQuest?.name}');
        uploadTaskQuest = ref.putData(bytes);

        final snapshot = await uploadTaskQuest!.whenComplete(() {});
        final urlDownload = await snapshot.ref.getDownloadURL();
        images[index] = urlDownload;
      }

      bool onUploadQuest = false;

      bool onUpload = false;

      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          Widget jawaban(int index) {
            bool answerSelected = trueAnswer[index] == controllers[index].text;

            PlatformFile? pickedFile;
            UploadTask? uploadTask;

            Future<void> selectedImage() async {
              final result = await FilePicker.platform.pickFiles(type: FileType.image);
              if (result == null) return;
              setState(() => pickedFile = result.files.first);
            }

            Future<void> uploadImage(int index) async {
              final bytes = pickedFile!.bytes!;
              final ref = FirebaseStorage.instance.ref().child('question_${tryout!.toName}/${pickedFile?.name}');
              uploadTask = ref.putData(bytes);

              final snapshot = await uploadTask!.whenComplete(() {});
              final urlDownload = await snapshot.ref.getDownloadURL();
              controllers[index] = TextEditingController(text: urlDownload);
              setState(() {});
            }

            return Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 10, 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: isUrl(controllers[index].text)
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              imageUrl: controllers[index].text,
                              fit: BoxFit.fitWidth,
                              placeholder: (context, url) => Center(child: CircularProgressIndicator(color: primary)),
                              errorWidget: (context, url, error) => const Icon(Icons.error),
                            ),
                          )
                        : SizedBox(
                            height: 40,
                            child: TextFormField(
                              controller: controllers[index],
                              style: TextStyle(color: Colors.black, fontSize: h4),
                              maxLines: 1,
                              decoration: InputDecoration(
                                label: Text('Jawaban', style: TextStyle(color: Colors.black, fontSize: h4)),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.black)),
                              ),
                            ),
                          ),
                  ),
                  (onUpload)
                      ? Container(height: 40, width: 40, padding: const EdgeInsets.all(5), child: const CircularProgressIndicator())
                      : IconButton(
                          onPressed: () async {
                            try {
                              setState(() => onUpload = !onUpload);
                              await selectedImage();
                              if (pickedFile != null) {
                                await uploadImage(index);
                              }
                              pickedFile = null;
                              setState(() => onUpload = !onUpload);
                            } catch (e) {
                              print('salah ni $e');
                            }
                          },
                          icon: const Icon(Icons.image, color: Colors.black),
                        ),
                  if (controllers.length > 1)
                    IconButton(
                      onPressed: () => setState(() {
                        controllers.removeAt(index);
                        trueAnswer.removeAt(index);
                      }),
                      icon: const Icon(Icons.delete, color: Colors.black),
                    ),
                  IconButton(
                    onPressed: () {
                      if (controllers[index].text.isNotEmpty) {
                        if (answerSelected) {
                          setState(() => trueAnswer[index] = ' ');
                        } else {
                          setState(() => trueAnswer[index] = controllers[index].text);
                        }
                      }
                    },
                    icon: Icon(answerSelected ? Icons.check_box : Icons.check_box_outline_blank_rounded, color: answerSelected ? primary : Colors.black),
                  ),
                ],
              ),
            );
          }

          return AlertDialog(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            title: Row(
              children: [
                Text('Masukkan Soal ', style: TextStyle(color: Colors.black, fontSize: h4, fontWeight: FontWeight.normal)),
                Container(
                  decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(50)),
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: Text('Banyak Pilihan', style: TextStyle(color: Colors.white, fontSize: h4, fontWeight: FontWeight.normal)),
                ),
              ],
            ),
            contentPadding: const EdgeInsets.all(5),
            content: SizedBox(
              width: 1300,
              child: SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Container(
                        height: 700,
                        decoration: BoxDecoration(color: secondaryWhite, borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 30,
                              margin: const EdgeInsets.fromLTRB(10, 10, 5, 0),
                              child: OutlinedButton.icon(
                                onPressed: () => setState(() {
                                  jmlImage++;
                                  images.add('');
                                }),
                                icon: const Icon(Icons.add, color: Colors.black),
                                label: Text('Tambah Soal Gambar', style: TextStyle(color: Colors.black, fontSize: h4)),
                              ),
                            ),
                            Row(
                              children: List.generate(
                                jmlImage,
                                (index) {
                                  return Container(
                                    width: 100,
                                    height: 200,
                                    margin: const EdgeInsets.fromLTRB(10, 10, 5, 0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          child: Container(
                                            color: Colors.white,
                                            child: AspectRatio(
                                              aspectRatio: 3 / 4,
                                              child: images[index] != ''
                                                  ? CachedNetworkImage(
                                                      imageUrl: images[index],
                                                      fit: BoxFit.cover,
                                                      placeholder: (context, url) => Center(child: CircularProgressIndicator(color: primary)),
                                                      errorWidget: (context, url, error) => const Icon(Icons.error),
                                                    )
                                                  : const Icon(Icons.image, color: Colors.grey),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 30,
                                          width: double.infinity,
                                          child: OutlinedButton(
                                            onPressed: () async {
                                              try {
                                                setState(() => onUploadQuest = !onUploadQuest);
                                                await selectedImageQuest();
                                                if (pickedFileQuest != null) {
                                                  await uploadImageQuest(index);
                                                }
                                                pickedFileQuest = null;
                                                setState(() => onUploadQuest = !onUploadQuest);
                                              } catch (e) {
                                                print('salah ni $e');
                                              }
                                              setState(() {});
                                            },
                                            style: OutlinedButton.styleFrom(padding: EdgeInsets.zero),
                                            child: Text(images[index] != '' ? 'Edit' : 'Tambah', style: TextStyle(color: Colors.black, fontSize: h4)),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 30,
                                          width: double.infinity,
                                          child: OutlinedButton(
                                            onPressed: () => setState(() {
                                              jmlImage--;
                                              images.removeAt(index);
                                            }),
                                            style: OutlinedButton.styleFrom(padding: EdgeInsets.zero),
                                            child: Text('Hapus', style: TextStyle(color: Colors.black, fontSize: h4)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                            QuillToolbar.simple(
                              configurations: QuillSimpleToolbarConfigurations(
                                controller: soalController,
                                color: Colors.black,
                                sharedConfigurations: const QuillSharedConfigurations(locale: Locale('id')),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.all(10),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                                child: QuillEditor.basic(
                                  configurations: QuillEditorConfigurations(
                                    controller: soalController,
                                    placeholder: 'Soal',
                                    customStyleBuilder: (attribute) => TextStyle(color: Colors.black, fontSize: h4),
                                    checkBoxReadOnly: false,
                                    sharedConfigurations: const QuillSharedConfigurations(locale: Locale('id')),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Column(children: List.generate(controllers.length, (index) => jawaban(index))),
                      SizedBox(
                        height: 40,
                        child: TextFormField(
                          controller: urlController,
                          style: TextStyle(color: Colors.black, fontSize: h4),
                          maxLines: 1,
                          decoration: InputDecoration(
                            labelText: 'Url video Penjelasan',
                            labelStyle: TextStyle(color: Colors.black, fontSize: h4),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.black)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(color: secondaryWhite, borderRadius: BorderRadius.circular(10)),
                        height: 400,
                        child: Column(
                          children: [
                            QuillToolbar.simple(
                              configurations: QuillSimpleToolbarConfigurations(
                                controller: deskController,
                                color: Colors.black,
                                sharedConfigurations: const QuillSharedConfigurations(locale: Locale('id')),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.all(10),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                                child: QuillEditor.basic(
                                  configurations: QuillEditorConfigurations(
                                    placeholder: 'Deskripsi Jawaban',
                                    customStyleBuilder: (attribute) => TextStyle(color: Colors.black, fontSize: h4),
                                    controller: deskController,
                                    checkBoxReadOnly: false,
                                    sharedConfigurations: const QuillSharedConfigurations(locale: Locale('id')),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actionsPadding: const EdgeInsets.all(10),
            actions: [
              Row(
                children: [
                  Expanded(
                    child: AnimatedContainer(
                      margin: const EdgeInsets.only(bottom: 10),
                      duration: const Duration(milliseconds: 300),
                      height: showHeight ? 40 : 0,
                      decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(50)),
                      alignment: Alignment.center,
                      child: Wrap(children: [Text('lengkapi form terlebih dahulu', style: TextStyle(color: Colors.white, fontSize: h4, fontWeight: FontWeight.bold))]),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: () => setState(() {
                      trueAnswer.add(' ');
                      controllers.add(TextEditingController());
                    }),
                    label: Text('Tambah Jawaban', style: TextStyle(color: Colors.black, fontSize: h4)),
                    icon: const Icon(Icons.add, color: Colors.black),
                  ),
                  const Expanded(child: SizedBox()),
                  TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('Batal', style: TextStyle(color: Colors.black, fontSize: h4))),
                  TextButton(
                    onPressed: () async {
                      List<String> options = [];
                      options.addAll(controllers.map((controller) => controller.text));
                      if (soalController.document.toDelta().isNotEmpty && deskController.document.toDelta().isNotEmpty && options.isNotEmpty) {
                        final soalConverter = QuillDeltaToHtmlConverter(soalController.document.toDelta().toJson(), ConverterOptions.forEmail());
                        final deskConverter = QuillDeltaToHtmlConverter(deskController.document.toDelta().toJson(), ConverterOptions.forEmail());

                        final soalHtml = soalConverter.convert();
                        final deskHtml = deskConverter.convert();

                        question!.listQuestions.add(
                          CheckModel(
                            question: soalHtml,
                            options: options,
                            trueAnswer: trueAnswer,
                            type: 'banyak_pilihan',
                            yourAnswer: [],
                            image: images,
                            value: null,
                            rating: 0,
                            urlVideoExplanation: urlController.text,
                            explanation: deskHtml,
                          ),
                        );

                        Navigator.of(context).pop();
                      } else {
                        setState(() => showHeight = !showHeight);
                        await Future.delayed(const Duration(seconds: 1));
                        setState(() => showHeight = !showHeight);
                      }
                    },
                    child: Text('Selesai', style: TextStyle(color: Colors.black, fontSize: h4)),
                  ),
                ],
              )
            ],
          );
        },
      );
    },
  );
}

Future<void> addPGDialogSmallDevice() async {
  String? trueAnswer;
  await showDialog(
    context: contextF!,
    builder: (BuildContext context) {
      bool showHeight = false;

      final QuillController soalController = QuillController.basic();
      final QuillController deskController = QuillController.basic();

      TextEditingController urlController = TextEditingController();
      List<TextEditingController> controllers = [TextEditingController()];

      PlatformFile? pickedFileQuest;
      UploadTask? uploadTaskQuest;

      List<String> images = [''];
      int jmlImage = 1;

      Future<void> selectedImageQuest() async {
        final result = await FilePicker.platform.pickFiles(type: FileType.image);
        if (result == null) return;
        pickedFileQuest = result.files.first;
      }

      Future<void> uploadImageQuest(int index) async {
        final bytes = pickedFileQuest!.bytes!;
        final ref = FirebaseStorage.instance.ref().child('question_${tryout!.toName}/${pickedFileQuest?.name}');
        uploadTaskQuest = ref.putData(bytes);

        final snapshot = await uploadTaskQuest!.whenComplete(() {});
        final urlDownload = await snapshot.ref.getDownloadURL();
        images[index] = urlDownload;
      }

      bool onUploadQuest = false;

      bool onUpload = false;

      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          Widget jawaban(int index) {
            bool answerSelected = trueAnswer == controllers[index].text;
            PlatformFile? pickedFile;
            UploadTask? uploadTask;

            Future<void> selectedImage() async {
              final result = await FilePicker.platform.pickFiles(type: FileType.image);
              if (result == null) return;
              setState(() => pickedFile = result.files.first);
            }

            Future<void> uploadImage(int index) async {
              final bytes = pickedFile!.bytes!;
              final ref = FirebaseStorage.instance.ref().child('question_${tryout!.toName}/${pickedFile?.name}');
              uploadTask = ref.putData(bytes);

              final snapshot = await uploadTask!.whenComplete(() {});
              final urlDownload = await snapshot.ref.getDownloadURL();
              controllers[index] = TextEditingController(text: urlDownload);
              setState(() {});
            }

            return Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 10, 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: isUrl(controllers[index].text)
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              imageUrl: controllers[index].text,
                              fit: BoxFit.fitWidth,
                              placeholder: (context, url) => Center(child: CircularProgressIndicator(color: primary)),
                              errorWidget: (context, url, error) => const Icon(Icons.error),
                            ),
                          )
                        : SizedBox(
                            height: 40,
                            child: TextFormField(
                              controller: controllers[index],
                              style: TextStyle(color: Colors.black, fontSize: h4),
                              maxLines: 1,
                              decoration: InputDecoration(
                                label: Text('Jawaban', style: TextStyle(color: Colors.black, fontSize: h4)),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.black)),
                              ),
                            ),
                          ),
                  ),
                  (onUpload)
                      ? Container(height: 40, width: 40, padding: const EdgeInsets.all(5), child: const CircularProgressIndicator())
                      : IconButton(
                          onPressed: () async {
                            try {
                              setState(() => onUpload = !onUpload);
                              await selectedImage();
                              if (pickedFile != null) {
                                await uploadImage(index);
                              }
                              pickedFile = null;
                              setState(() => onUpload = !onUpload);
                            } catch (e) {
                              print('salah ni $e');
                            }
                          },
                          icon: const Icon(Icons.image, color: Colors.black),
                        ),
                  if (controllers.length > 1)
                    IconButton(
                      onPressed: () => setState(() => controllers.removeAt(index)),
                      icon: const Icon(Icons.delete, color: Colors.black),
                    ),
                  IconButton(
                    onPressed: () {
                      if (controllers[index].text.isNotEmpty) {
                        setState(() => trueAnswer = controllers[index].text);
                      }
                    },
                    icon: Icon(answerSelected ? Icons.check_circle : Icons.cancel, color: answerSelected ? primary : secondary),
                  ),
                ],
              ),
            );
          }

          return AlertDialog(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            title: Row(
              children: [
                Text('Masukkan Soal ', style: TextStyle(color: Colors.black, fontSize: h4, fontWeight: FontWeight.normal)),
                Container(
                  decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(50)),
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: Text('Pilihan Ganda', style: TextStyle(color: Colors.white, fontSize: h4, fontWeight: FontWeight.normal)),
                ),
              ],
            ),
            contentPadding: const EdgeInsets.all(5),
            content: SizedBox(
              width: 1300,
              child: SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Container(
                        height: 700,
                        decoration: BoxDecoration(color: secondaryWhite, borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 30,
                              margin: const EdgeInsets.fromLTRB(10, 10, 5, 0),
                              child: OutlinedButton.icon(
                                onPressed: () => setState(() {
                                  jmlImage++;
                                  images.add('');
                                }),
                                icon: const Icon(Icons.add, color: Colors.black),
                                label: Text('Tambah Soal Gambar', style: TextStyle(color: Colors.black, fontSize: h4)),
                              ),
                            ),
                            Row(
                              children: List.generate(
                                jmlImage,
                                (index) {
                                  return Container(
                                    width: 100,
                                    height: 200,
                                    margin: const EdgeInsets.fromLTRB(10, 10, 5, 0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          child: Container(
                                            color: Colors.white,
                                            child: AspectRatio(
                                              aspectRatio: 3 / 4,
                                              child: images[index] != ''
                                                  ? CachedNetworkImage(
                                                      imageUrl: images[index],
                                                      fit: BoxFit.cover,
                                                      placeholder: (context, url) => Center(child: CircularProgressIndicator(color: primary)),
                                                      errorWidget: (context, url, error) => const Icon(Icons.error),
                                                    )
                                                  : const Icon(Icons.image, color: Colors.grey),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 30,
                                          width: double.infinity,
                                          child: OutlinedButton(
                                            onPressed: () async {
                                              try {
                                                setState(() => onUploadQuest = !onUploadQuest);
                                                await selectedImageQuest();
                                                if (pickedFileQuest != null) {
                                                  await uploadImageQuest(index);
                                                }
                                                pickedFileQuest = null;
                                                setState(() => onUploadQuest = !onUploadQuest);
                                              } catch (e) {
                                                print('salah ni $e');
                                              }
                                              setState(() {});
                                            },
                                            style: OutlinedButton.styleFrom(padding: EdgeInsets.zero),
                                            child: Text(images[index] != '' ? 'Edit' : 'Tambah', style: TextStyle(color: Colors.black, fontSize: h4)),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 30,
                                          width: double.infinity,
                                          child: OutlinedButton(
                                            onPressed: () => setState(() {
                                              jmlImage--;
                                              images.removeAt(index);
                                            }),
                                            style: OutlinedButton.styleFrom(padding: EdgeInsets.zero),
                                            child: Text('Hapus', style: TextStyle(color: Colors.black, fontSize: h4)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                            QuillToolbar.simple(
                              configurations: QuillSimpleToolbarConfigurations(
                                controller: soalController,
                                color: Colors.black,
                                sharedConfigurations: const QuillSharedConfigurations(locale: Locale('id')),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.all(10),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                                child: QuillEditor.basic(
                                  configurations: QuillEditorConfigurations(
                                    controller: soalController,
                                    placeholder: 'Soal',
                                    customStyleBuilder: (attribute) => TextStyle(color: Colors.black, fontSize: h4),
                                    checkBoxReadOnly: false,
                                    sharedConfigurations: const QuillSharedConfigurations(locale: Locale('id')),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Column(children: List.generate(controllers.length, (index) => jawaban(index))),
                      SizedBox(
                        height: 40,
                        child: TextFormField(
                          controller: urlController,
                          style: TextStyle(color: Colors.black, fontSize: h4),
                          maxLines: 1,
                          decoration: InputDecoration(
                            labelText: 'Url video Penjelasan',
                            labelStyle: TextStyle(color: Colors.black, fontSize: h4),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.black)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(color: secondaryWhite, borderRadius: BorderRadius.circular(10)),
                        height: 400,
                        child: Column(
                          children: [
                            QuillToolbar.simple(
                              configurations: QuillSimpleToolbarConfigurations(
                                controller: deskController,
                                color: Colors.black,
                                sharedConfigurations: const QuillSharedConfigurations(locale: Locale('id')),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.all(10),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                                child: QuillEditor.basic(
                                  configurations: QuillEditorConfigurations(
                                    placeholder: 'Deskripsi Jawaban',
                                    customStyleBuilder: (attribute) => TextStyle(color: Colors.black, fontSize: h4),
                                    controller: deskController,
                                    checkBoxReadOnly: false,
                                    sharedConfigurations: const QuillSharedConfigurations(locale: Locale('id')),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actionsPadding: const EdgeInsets.all(10),
            actions: [
              Row(
                children: [
                  Expanded(
                    child: AnimatedContainer(
                      margin: const EdgeInsets.only(bottom: 10),
                      duration: const Duration(milliseconds: 300),
                      height: showHeight ? 40 : 0,
                      decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(50)),
                      alignment: Alignment.center,
                      child: Wrap(children: [Text('lengkapi form terlebih dahulu', style: TextStyle(color: Colors.white, fontSize: h4, fontWeight: FontWeight.bold))]),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: () => setState(() => controllers.add(TextEditingController())),
                    label: Text('Tambah Jawaban', style: TextStyle(color: Colors.black, fontSize: h4)),
                    icon: const Icon(Icons.add, color: Colors.black),
                  ),
                  const Expanded(child: SizedBox()),
                  TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('Batal', style: TextStyle(color: Colors.black, fontSize: h4))),
                  TextButton(
                    onPressed: () async {
                      List<String> options = [];
                      options.addAll(controllers.map((controller) => controller.text));
                      if (trueAnswer != null &&
                          soalController.document.toDelta().isNotEmpty &&
                          deskController.document.toDelta().isNotEmpty &&
                          urlController.text.isNotEmpty &&
                          options.isNotEmpty) {
                        final soalConverter = QuillDeltaToHtmlConverter(soalController.document.toDelta().toJson(), ConverterOptions.forEmail());
                        final deskConverter = QuillDeltaToHtmlConverter(deskController.document.toDelta().toJson(), ConverterOptions.forEmail());

                        final soalHtml = soalConverter.convert();
                        final deskHtml = deskConverter.convert();

                        question!.listQuestions.add(
                          PgModel(
                            question: soalHtml,
                            options: options,
                            trueAnswer: trueAnswer!,
                            type: 'pilihan_ganda',
                            yourAnswer: [],
                            image: images,
                            value: null,
                            rating: 0,
                            urlVideoExplanation: urlController.text,
                            explanation: deskHtml,
                          ),
                        );

                        Navigator.of(context).pop();
                      } else {
                        setState(() => showHeight = !showHeight);
                        await Future.delayed(const Duration(seconds: 1));
                        setState(() => showHeight = !showHeight);
                      }
                    },
                    child: Text('Selesai', style: TextStyle(color: Colors.black, fontSize: h4)),
                  ),
                ],
              )
            ],
          );
        },
      );
    },
  );
}

Future<void> addIsianDialogSmallDevice() async {
  await showDialog(
    context: contextF!,
    builder: (BuildContext context) {
      bool showHeight = false;

      final QuillController soalController = QuillController.basic();
      final QuillController deskController = QuillController.basic();

      TextEditingController urlController = TextEditingController();
      TextEditingController trueAnswerController = TextEditingController();

      PlatformFile? pickedFileQuest;
      UploadTask? uploadTaskQuest;

      List<String> images = [''];
      int jmlImage = 1;

      Future<void> selectedImageQuest() async {
        final result = await FilePicker.platform.pickFiles(type: FileType.image);
        if (result == null) return;
        pickedFileQuest = result.files.first;
      }

      Future<void> uploadImageQuest(int index) async {
        final bytes = pickedFileQuest!.bytes!;
        final ref = FirebaseStorage.instance.ref().child('question_${tryout!.toName}/${pickedFileQuest?.name}');
        uploadTaskQuest = ref.putData(bytes);

        final snapshot = await uploadTaskQuest!.whenComplete(() {});
        final urlDownload = await snapshot.ref.getDownloadURL();
        images[index] = urlDownload;
      }

      bool onUploadQuest = false;
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            title: Row(
              children: [
                Text('Masukkan Soal ', style: TextStyle(color: Colors.black, fontSize: h4, fontWeight: FontWeight.normal)),
                Container(
                  decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(50)),
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: Text('Isian', style: TextStyle(color: Colors.white, fontSize: h4, fontWeight: FontWeight.normal)),
                ),
              ],
            ),
            contentPadding: const EdgeInsets.all(5),
            content: SizedBox(
              width: 1300,
              child: SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Container(
                        height: 700,
                        decoration: BoxDecoration(color: secondaryWhite, borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 30,
                              margin: const EdgeInsets.fromLTRB(10, 10, 5, 0),
                              child: OutlinedButton.icon(
                                onPressed: () => setState(() {
                                  jmlImage++;
                                  images.add('');
                                }),
                                icon: const Icon(Icons.add, color: Colors.black),
                                label: Text('Tambah Soal Gambar', style: TextStyle(color: Colors.black, fontSize: h4)),
                              ),
                            ),
                            Row(
                              children: List.generate(
                                jmlImage,
                                (index) {
                                  return Container(
                                    width: 100,
                                    height: 200,
                                    margin: const EdgeInsets.fromLTRB(10, 10, 5, 0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          child: Container(
                                            color: Colors.white,
                                            child: AspectRatio(
                                              aspectRatio: 3 / 4,
                                              child: images[index] != ''
                                                  ? CachedNetworkImage(
                                                      imageUrl: images[index],
                                                      fit: BoxFit.cover,
                                                      placeholder: (context, url) => Center(child: CircularProgressIndicator(color: primary)),
                                                      errorWidget: (context, url, error) => const Icon(Icons.error),
                                                    )
                                                  : const Icon(Icons.image, color: Colors.grey),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 30,
                                          width: double.infinity,
                                          child: OutlinedButton(
                                            onPressed: () async {
                                              try {
                                                setState(() => onUploadQuest = !onUploadQuest);
                                                await selectedImageQuest();
                                                if (pickedFileQuest != null) {
                                                  await uploadImageQuest(index);
                                                }
                                                pickedFileQuest = null;
                                                setState(() => onUploadQuest = !onUploadQuest);
                                              } catch (e) {
                                                print('salah ni $e');
                                              }
                                              setState(() {});
                                            },
                                            style: OutlinedButton.styleFrom(padding: EdgeInsets.zero),
                                            child: Text(images[index] != '' ? 'Edit' : 'Tambah', style: TextStyle(color: Colors.black, fontSize: h4)),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 30,
                                          width: double.infinity,
                                          child: OutlinedButton(
                                            onPressed: () => setState(() {
                                              jmlImage--;
                                              images.removeAt(index);
                                            }),
                                            style: OutlinedButton.styleFrom(padding: EdgeInsets.zero),
                                            child: Text('Hapus', style: TextStyle(color: Colors.black, fontSize: h4)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                            QuillToolbar.simple(
                              configurations: QuillSimpleToolbarConfigurations(
                                controller: soalController,
                                color: Colors.black,
                                sharedConfigurations: const QuillSharedConfigurations(locale: Locale('id')),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.all(10),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                                child: QuillEditor.basic(
                                  configurations: QuillEditorConfigurations(
                                    controller: soalController,
                                    placeholder: 'Soal',
                                    customStyleBuilder: (attribute) => TextStyle(color: Colors.black, fontSize: h4),
                                    checkBoxReadOnly: false,
                                    sharedConfigurations: const QuillSharedConfigurations(locale: Locale('id')),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 40,
                        child: TextFormField(
                          controller: trueAnswerController,
                          style: TextStyle(color: Colors.black, fontSize: h4),
                          maxLines: 1,
                          decoration: InputDecoration(
                            label: Text('Jawaban', style: TextStyle(color: Colors.black, fontSize: h4)),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.black)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 40,
                        child: TextFormField(
                          controller: urlController,
                          style: TextStyle(color: Colors.black, fontSize: h4),
                          maxLines: 1,
                          decoration: InputDecoration(
                            labelText: 'Url video Penjelasan',
                            labelStyle: TextStyle(color: Colors.black, fontSize: h4),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.black)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(color: secondaryWhite, borderRadius: BorderRadius.circular(10)),
                        height: 400,
                        child: Column(
                          children: [
                            QuillToolbar.simple(
                              configurations: QuillSimpleToolbarConfigurations(
                                controller: deskController,
                                color: Colors.black,
                                sharedConfigurations: const QuillSharedConfigurations(locale: Locale('id')),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.all(10),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                                child: QuillEditor.basic(
                                  configurations: QuillEditorConfigurations(
                                    placeholder: 'Deskripsi Jawaban',
                                    customStyleBuilder: (attribute) => TextStyle(color: Colors.black, fontSize: h4),
                                    controller: deskController,
                                    checkBoxReadOnly: false,
                                    sharedConfigurations: const QuillSharedConfigurations(locale: Locale('id')),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actionsPadding: const EdgeInsets.all(10),
            actions: [
              Row(
                children: [
                  Expanded(
                    child: AnimatedContainer(
                      margin: const EdgeInsets.only(bottom: 10),
                      duration: const Duration(milliseconds: 300),
                      height: showHeight ? 40 : 0,
                      decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(50)),
                      alignment: Alignment.center,
                      child: Wrap(children: [Text('lengkapi form terlebih dahulu', style: TextStyle(color: Colors.white, fontSize: h4, fontWeight: FontWeight.bold))]),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('Batal', style: TextStyle(color: Colors.black, fontSize: h4))),
                  TextButton(
                    onPressed: () async {
                      if (trueAnswerController.text.isNotEmpty &&
                          soalController.document.toDelta().isNotEmpty &&
                          deskController.document.toDelta().isNotEmpty &&
                          urlController.text.isNotEmpty) {
                        final soalConverter = QuillDeltaToHtmlConverter(soalController.document.toDelta().toJson(), ConverterOptions.forEmail());
                        final deskConverter = QuillDeltaToHtmlConverter(deskController.document.toDelta().toJson(), ConverterOptions.forEmail());

                        final soalHtml = soalConverter.convert();
                        final deskHtml = deskConverter.convert();
                        question!.listQuestions.add(StuffingModel(
                          question: soalHtml,
                          trueAnswer: trueAnswerController.text,
                          type: 'isian',
                          yourAnswer: [],
                          image: images,
                          value: null,
                          rating: null,
                          urlVideoExplanation: urlController.text,
                          explanation: deskHtml,
                        ));

                        setState(() {});
                        Navigator.of(context).pop();
                      } else {
                        setState(() => showHeight = !showHeight);
                        await Future.delayed(const Duration(seconds: 1));
                        setState(() => showHeight = !showHeight);
                      }
                    },
                    child: Text('Selesai', style: TextStyle(color: Colors.black, fontSize: h4)),
                  ),
                ],
              ),
            ],
          );
        },
      );
    },
  );
}

Future<void> addBenarSalahDialogSmallDevice() async {
  await showDialog(
    context: contextF!,
    builder: (BuildContext context) {
      bool showHeight = false;

      final QuillController soalController = QuillController.basic();
      final QuillController deskController = QuillController.basic();

      TextEditingController urlController = TextEditingController();

      List<bool> trueAnswer = [false];
      List<TextEditingController> controllers = [TextEditingController()];

      PlatformFile? pickedFileQuest;
      UploadTask? uploadTaskQuest;

      List<String> images = [''];
      int jmlImage = 1;

      Future<void> selectedImageQuest() async {
        final result = await FilePicker.platform.pickFiles(type: FileType.image);
        if (result == null) return;
        pickedFileQuest = result.files.first;
      }

      Future<void> uploadImageQuest(int index) async {
        final bytes = pickedFileQuest!.bytes!;
        final ref = FirebaseStorage.instance.ref().child('question_${tryout!.toName}/${pickedFileQuest?.name}');
        uploadTaskQuest = ref.putData(bytes);

        final snapshot = await uploadTaskQuest!.whenComplete(() {});
        final urlDownload = await snapshot.ref.getDownloadURL();
        images[index] = urlDownload;
      }

      bool onUploadQuest = false;

      bool onUpload = false;

      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          Widget jawaban(int index) {
            PlatformFile? pickedFile;
            UploadTask? uploadTask;

            Future<void> selectedImage() async {
              final result = await FilePicker.platform.pickFiles(type: FileType.image);
              if (result == null) return;
              setState(() => pickedFile = result.files.first);
            }

            Future<void> uploadImage(int index) async {
              final bytes = pickedFile!.bytes!;
              final ref = FirebaseStorage.instance.ref().child('question_${tryout!.toName}/${pickedFile?.name}');
              uploadTask = ref.putData(bytes);

              final snapshot = await uploadTask!.whenComplete(() {});
              final urlDownload = await snapshot.ref.getDownloadURL();
              controllers[index] = TextEditingController(text: urlDownload);
              setState(() {});
            }

            return Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 10, 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: isUrl(controllers[index].text)
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              imageUrl: controllers[index].text,
                              fit: BoxFit.fitWidth,
                              placeholder: (context, url) => Center(child: CircularProgressIndicator(color: primary)),
                              errorWidget: (context, url, error) => const Icon(Icons.error),
                            ),
                          )
                        : SizedBox(
                            height: 40,
                            child: TextFormField(
                              controller: controllers[index],
                              style: TextStyle(color: Colors.black, fontSize: h4),
                              maxLines: 1,
                              decoration: InputDecoration(
                                label: Text('Jawaban', style: TextStyle(color: Colors.black, fontSize: h4)),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.black)),
                              ),
                            ),
                          ),
                  ),
                  (onUpload)
                      ? Container(height: 40, width: 40, padding: const EdgeInsets.all(5), child: const CircularProgressIndicator())
                      : IconButton(
                          onPressed: () async {
                            try {
                              setState(() => onUpload = !onUpload);
                              await selectedImage();
                              if (pickedFile != null) {
                                await uploadImage(index);
                              }
                              pickedFile = null;
                              setState(() => onUpload = !onUpload);
                            } catch (e) {
                              print('salah ni $e');
                            }
                          },
                          icon: const Icon(Icons.image, color: Colors.black),
                        ),
                  if (controllers.length > 1)
                    IconButton(
                      onPressed: () => setState(() {
                        controllers.removeAt(index);
                        trueAnswer.removeAt(index);
                      }),
                      icon: const Icon(Icons.delete, color: Colors.black),
                    ),
                  const SizedBox(width: 10),
                  TextButton(
                    style: TextButton.styleFrom(backgroundColor: trueAnswer[index] ? primary : secondary),
                    onPressed: () {
                      if (controllers[index].text.isNotEmpty) {
                        setState(() => trueAnswer[index] = !(trueAnswer[index]));
                      }
                    },
                    child: Text(trueAnswer[index] ? 'Benar' : 'Salah', style: TextStyle(color: Colors.white, fontSize: h4, fontWeight: FontWeight.normal)),
                  ),
                ],
              ),
            );
          }

          return AlertDialog(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            title: Row(
              children: [
                Text('Masukkan Soal ', style: TextStyle(color: Colors.black, fontSize: h4, fontWeight: FontWeight.normal)),
                Container(
                  decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(50)),
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: Text('Benar Salah', style: TextStyle(color: Colors.white, fontSize: h4, fontWeight: FontWeight.normal)),
                ),
              ],
            ),
            contentPadding: const EdgeInsets.all(5),
            content: SizedBox(
              width: 1300,
              child: SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Container(
                        height: 700,
                        decoration: BoxDecoration(color: secondaryWhite, borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 30,
                              margin: const EdgeInsets.fromLTRB(10, 10, 5, 0),
                              child: OutlinedButton.icon(
                                onPressed: () => setState(() {
                                  jmlImage++;
                                  images.add('');
                                }),
                                icon: const Icon(Icons.add, color: Colors.black),
                                label: Text('Tambah Soal Gambar', style: TextStyle(color: Colors.black, fontSize: h4)),
                              ),
                            ),
                            Row(
                              children: List.generate(
                                jmlImage,
                                (index) {
                                  return Container(
                                    width: 100,
                                    height: 200,
                                    margin: const EdgeInsets.fromLTRB(10, 10, 5, 0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          child: Container(
                                            color: Colors.white,
                                            child: AspectRatio(
                                              aspectRatio: 3 / 4,
                                              child: images[index] != ''
                                                  ? CachedNetworkImage(
                                                      imageUrl: images[index],
                                                      fit: BoxFit.cover,
                                                      placeholder: (context, url) => Center(child: CircularProgressIndicator(color: primary)),
                                                      errorWidget: (context, url, error) => const Icon(Icons.error),
                                                    )
                                                  : const Icon(Icons.image, color: Colors.grey),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 30,
                                          width: double.infinity,
                                          child: OutlinedButton(
                                            onPressed: () async {
                                              try {
                                                setState(() => onUploadQuest = !onUploadQuest);
                                                await selectedImageQuest();
                                                if (pickedFileQuest != null) {
                                                  await uploadImageQuest(index);
                                                }
                                                pickedFileQuest = null;
                                                setState(() => onUploadQuest = !onUploadQuest);
                                              } catch (e) {
                                                print('salah ni $e');
                                              }
                                              setState(() {});
                                            },
                                            style: OutlinedButton.styleFrom(padding: EdgeInsets.zero),
                                            child: Text(images[index] != '' ? 'Edit' : 'Tambah', style: TextStyle(color: Colors.black, fontSize: h4)),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 30,
                                          width: double.infinity,
                                          child: OutlinedButton(
                                            onPressed: () => setState(() {
                                              jmlImage--;
                                              images.removeAt(index);
                                            }),
                                            style: OutlinedButton.styleFrom(padding: EdgeInsets.zero),
                                            child: Text('Hapus', style: TextStyle(color: Colors.black, fontSize: h4)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                            QuillToolbar.simple(
                              configurations: QuillSimpleToolbarConfigurations(
                                controller: soalController,
                                color: Colors.black,
                                sharedConfigurations: const QuillSharedConfigurations(locale: Locale('id')),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.all(10),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                                child: QuillEditor.basic(
                                  configurations: QuillEditorConfigurations(
                                    controller: soalController,
                                    placeholder: 'Soal',
                                    customStyleBuilder: (attribute) => TextStyle(color: Colors.black, fontSize: h4),
                                    checkBoxReadOnly: false,
                                    sharedConfigurations: const QuillSharedConfigurations(locale: Locale('id')),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Column(children: List.generate(trueAnswer.length, (index) => jawaban(index))),
                      SizedBox(
                        height: 40,
                        child: TextFormField(
                          controller: urlController,
                          style: TextStyle(color: Colors.black, fontSize: h4),
                          maxLines: 1,
                          decoration: InputDecoration(
                            labelText: 'Url video Penjelasan',
                            labelStyle: TextStyle(color: Colors.black, fontSize: h4),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.black)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(color: secondaryWhite, borderRadius: BorderRadius.circular(10)),
                        height: 400,
                        child: Column(
                          children: [
                            QuillToolbar.simple(
                              configurations: QuillSimpleToolbarConfigurations(
                                controller: deskController,
                                color: Colors.black,
                                sharedConfigurations: const QuillSharedConfigurations(locale: Locale('id')),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.all(10),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                                child: QuillEditor.basic(
                                  configurations: QuillEditorConfigurations(
                                    placeholder: 'Deskripsi Jawaban',
                                    customStyleBuilder: (attribute) => TextStyle(color: Colors.black, fontSize: h4),
                                    controller: deskController,
                                    checkBoxReadOnly: false,
                                    sharedConfigurations: const QuillSharedConfigurations(locale: Locale('id')),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actionsPadding: const EdgeInsets.all(10),
            actions: [
              Row(
                children: [
                  Expanded(
                    child: AnimatedContainer(
                      margin: const EdgeInsets.only(bottom: 10),
                      duration: const Duration(milliseconds: 300),
                      height: showHeight ? 40 : 0,
                      decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(50)),
                      alignment: Alignment.center,
                      child: Wrap(children: [Text('lengkapi form terlebih dahulu', style: TextStyle(color: Colors.white, fontSize: h4, fontWeight: FontWeight.bold))]),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: () => setState(() {
                      trueAnswer.add(false);
                      controllers.add(TextEditingController());
                    }),
                    label: Text('Tambah Jawaban', style: TextStyle(color: Colors.black, fontSize: h4)),
                    icon: const Icon(Icons.add, color: Colors.black),
                  ),
                  const Expanded(child: SizedBox()),
                  TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('Batal', style: TextStyle(color: Colors.black, fontSize: h4))),
                  TextButton(
                    onPressed: () async {
                      final List<TrueFalseOption> options = List.generate(
                        trueAnswer.length,
                        (index) => TrueFalseOption(option: controllers[index].text, trueAnswer: trueAnswer[index]),
                      );
                      if (soalController.document.toDelta().isNotEmpty && deskController.document.toDelta().isNotEmpty && urlController.text.isNotEmpty && options.isNotEmpty) {
                        final soalConverter = QuillDeltaToHtmlConverter(soalController.document.toDelta().toJson(), ConverterOptions.forEmail());
                        final deskConverter = QuillDeltaToHtmlConverter(deskController.document.toDelta().toJson(), ConverterOptions.forEmail());

                        final soalHtml = soalConverter.convert();
                        final deskHtml = deskConverter.convert();
                        question!.listQuestions.add(
                          TrueFalseModel(
                            question: soalHtml,
                            trueAnswer: options,
                            type: 'benar_salah',
                            yourAnswer: [],
                            image: images,
                            value: null,
                            rating: 0,
                            urlVideoExplanation: urlController.text,
                            explanation: deskHtml,
                          ),
                        );

                        Navigator.of(context).pop();
                      } else {
                        setState(() => showHeight = !showHeight);
                        await Future.delayed(const Duration(seconds: 1));
                        setState(() => showHeight = !showHeight);
                      }
                    },
                    child: Text('Selesai', style: TextStyle(color: Colors.black, fontSize: h4)),
                  ),
                ],
              )
            ],
          );
        },
      );
    },
  );
}
