import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learn_link/controller/usercontroller.dart';
import 'package:learn_link/core/routes/app_routes.dart';
import 'package:learn_link/core/widgets/custom_button.dart';
import 'package:learn_link/core/widgets/entry_field.dart';
import 'package:learn_link/core/widgets/text_widgets.dart';
import 'package:learn_link/core/widgets/widgets.dart';
import 'package:learn_link/view/letter_reversal/view/letter_reversal.dart';
import 'package:learn_link/view/small_kids/memory_pattern/memory_pattern_ui.dart';


class GuardianDashboard extends StatefulWidget {
  @override
  State<GuardianDashboard> createState() => _GuardianDashboardState();
}

class _GuardianDashboardState extends State<GuardianDashboard> with TickerProviderStateMixin {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  late TabController tabController;
  UserController controller=Get.put(UserController());
  List<Map<String, String>> studentHistory = [];

  bool isDyslexic = false;
  bool parentHistory = false;
  String? selectedGender;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  void registerStudent() {
    if (nameController.text.isNotEmpty && ageController.text.isNotEmpty && selectedGender != null) {
      setState(() {
        studentHistory.add({
          'name': nameController.text.trim(),
          'age': ageController.text.trim(),
          'gender': selectedGender!,
          'label': isDyslexic ? 'Dyslexic' : 'Non Dyslexic',
          'parentHistory': parentHistory ? 'Yes' : 'No',
        });

        nameController.clear();
        ageController.clear();
        selectedGender = null;
        isDyslexic = false;
        parentHistory = false;
        FocusScope.of(context).unfocus();
        tabController.animateTo(1);
      });
    } else {
      Get.snackbar('Error', 'Please fill all fields',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  void labelStudent(int index, String label) {
    setState(() {
      studentHistory[index]['label'] = label;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:(){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Texts.textNormal("Guardian Dashboard"),
          actions: [
            GestureDetector(
                onTap: (){
                  controller.logOutUser();
                },
                child: Icon(Icons.login,color: Colors.red,)),
            SizedBox(width: 10,),
          ],
          centerTitle: true,
          backgroundColor: Colors.teal,
        ),
        body: Column(
          children: [
            TabBar(
              controller: tabController,
              tabs: const [
                Tab(text: "Register Student"),
                Tab(text: "Student History"),
              ],
              labelColor: Colors.teal,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.teal
              ,
            ),
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: [
                  // Register Student Tab
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          EntryField(
                            controller: nameController,
                            label: "Student Name",
                            hint: "Enter your name",

                          ),
                          Widgets.heightSpaceH05,
                          EntryField(
                            controller: ageController,
                            label: "Student Age",
                            hint: "Enter your age",
                            textInputType: TextInputType.number,

                          ),
                         Widgets.heightSpaceH05,
                          Texts.textMedium("Gender:",size: 14),
                          DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            ),
                            value: selectedGender,
                            items: ['Male', 'Female', 'Other'].map((gender) {
                              return DropdownMenuItem<String>(
                                value: gender,
                                child: Texts.textNormal(gender),
                              );
                            }).toList(),
                            onChanged: (value) => setState(() => selectedGender = value),
                          ),
                         Widgets.heightSpaceH05,
                          Row(
                            children: [
                              Texts.textMedium("Dyslexic Condition: ",size: 14),
                              Row(
                                children: [
                                  Texts.textNormal("Normal",size: 14),
                                  Transform.scale(
                                    scale: 0.7,
                                    child: Switch(
                                      value: isDyslexic,
                                      onChanged: (value) => setState(() => isDyslexic = value),
                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      activeColor: Colors.white, // thumb color
                                      activeTrackColor: Colors.teal, // track color when ON
                                      inactiveTrackColor: Colors.grey.shade300,
                                    ),
                                  ),
                                  Texts.textNormal("Dyslexic",size: 14),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Texts.textMedium("Parent History of Dyslexia: ",size: 14),
                              Row(
                                children: [
                                  Texts.textNormal("No",size: 14),
                                  Transform.scale(
                                    scale: 0.7,
                                    child: Switch(
                                      value: parentHistory,
                                      onChanged: (value) => setState(() => parentHistory = value),
                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      activeColor: Colors.white, // thumb color
                                      activeTrackColor: Colors.teal, // track color when ON
                                      inactiveTrackColor: Colors.grey.shade300, // optional: track color when OFF
                                    ),
                                  ),

                                  Texts.textNormal("Yes",size: 14),
                                ],
                              ),
                            ],
                          ),
                          Widgets.heightSpaceH3,
                          Widgets.heightSpaceH3,
                          CustomButton(
                            onTap: registerStudent,
                            label: "Register Student",
                            backgroundColor: Colors.teal,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Student History Tab
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: ListView.builder(
                      itemCount: studentHistory.length,
                      itemBuilder: (context, index) {
                        final student = studentHistory[index];
                        return _buildStudentCard(student);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildStudentCard(Map<String, dynamic> student) {
  return Card(
    elevation: 0.5,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name and Label in same row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                Texts.textBold(
                  "Name: ",
                  size: 12

                ),
                Texts.textNormal(
                  student['name'] ?? 'Unnamed',
                    size: 12

                ),
              ],),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.teal.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Texts.textNormal(
                  student['label'] ?? 'N/A',
                  color: student['label']=="Dyslexic"?Colors.red:Colors.teal,
                  size: 12,
                  fontWeight: FontWeight.bold

                ),
              ),
            ],
          ),


          // Age, Gender, Parent History
          Row(
            children: [
              Texts.textBold(
                  "age: ",
                  size: 14

              ),
              Texts.textNormal("${student['age'] ?? 'N/A'}",size: 14),

            ],
          ),
          Widgets.heightSpaceH1,
          Row(
            children: [


              Texts.textBold(
                  "gender: ",
                  size: 14

              ),
              Texts.textNormal("${student['gender'] ?? 'N/A'}",size: 14),
            ],
          ),
          Widgets.heightSpaceH1,
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Texts.textBold("Dyslexic family history: ",size: 14),
              Texts.textNormal("${student['parentHistory'] ?? 'N/A'}",size: 14),
            ],
          ),
        Widgets.heightSpaceH3,

          // Action Button
          Align(
            alignment: Alignment.centerRight,
            child: CustomButton(

              label: "Start Diagnosis",
              backgroundColor: Colors.teal,
              onTap: () {
                showDialog(
                  context: Get.context!,
                  builder: (context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      title: Texts.textBold("Can the student read?",size: 16),
                      content: Texts.textNormal("Please confirm whether the student is able to read or not.",size: 14),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); // Close dialog
                            // Navigate to screen for reading students
                            Get.toNamed(AppRoutes.letterReversal);
                          },
                          child: Texts.textBold("Yes",color: Colors.green,size: 14),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); // Close dialog

                            Get.to(()=>PatternMemoryScreen());
                          },
                          child: Texts.textBold("No",color: Colors.red,size: 14),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); // Just dismiss
                          },
                          child: Texts.textBold("Cancel",color: Colors.black,size: 14),
                        ),
                      ],
                    );
                  },
                );
              },

            ),
          ),
        ],
      ),
    ),
  );
}
