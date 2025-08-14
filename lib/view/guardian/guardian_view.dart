import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learn_link/controller/usercontroller.dart';
import 'package:learn_link/core/widgets/custom_button.dart';
import 'package:learn_link/core/widgets/entry_field.dart';
import 'package:learn_link/core/widgets/text_widgets.dart';
import 'package:learn_link/core/widgets/widgets.dart';
import 'package:learn_link/view/guardian/controller.dart';

class GuardianDashboard extends StatefulWidget {
  @override
  State<GuardianDashboard> createState() => _GuardianDashboardState();
}

class _GuardianDashboardState extends State<GuardianDashboard>
    with TickerProviderStateMixin {
  final guardianController = Get.put(GuardianController());

  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  late TabController tabController;
  UserController controller = Get.put(UserController());



  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      if (tabController.index == 1 && !tabController.indexIsChanging) {
        guardianController.getRegisteredStudents();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Texts.textNormal("Guardian Dashboard"),
          centerTitle: true,
          backgroundColor: Colors.teal,
        ),
        body: Column(
          children: [
            TabBar(
              controller: tabController,
              tabs: const [
                Tab(text: "Register Student"),
                Tab(text: "Registered Students"),
              ],
              labelColor: Colors.teal,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.teal,
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
                          Texts.textMedium("Gender:", size: 14),
                          Obx(
                            () => DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 4),
                              ),
                              value: guardianController.selectedGender.value,
                              items: ['Male', 'Female', 'Other'].map((gender) {
                                return DropdownMenuItem<String>(
                                  value: gender,
                                  child: Texts.textNormal(gender),
                                );
                              }).toList(),
                              onChanged: (value) => guardianController
                                  .selectedGender.value = value.toString(),
                            ),
                          ),

                          Widgets.heightSpaceH05,

                          Row(
                            children: [
                              Texts.textMedium("Parent History of Dyslexia: ",
                                  size: 14),
                              Row(
                                children: [
                                  Texts.textNormal("No", size: 14),
                                  Obx(
                                    () => Transform.scale(
                                      scale: 0.7,
                                      child: Switch(
                                        value: guardianController
                                            .hasParentHistory.value,
                                        onChanged: (value) {
                                          guardianController.hasParentHistory.value = value;
                                          print("Parent History switched to: $value");
                                        },


                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        activeColor:
                                            Colors.white, // thumb color
                                        activeTrackColor:
                                            Colors.teal, // track color when ON
                                        inactiveTrackColor: Colors.grey
                                            .shade300, // optional: track color when OFF
                                      ),
                                    ),
                                  ),
                                  Texts.textNormal("Yes", size: 14),
                                ],
                              ),
                            ],
                          ),
                          Widgets.heightSpaceH3,
                          Widgets.heightSpaceH3,
                        CustomButton(
                            onTap: () {
                              if (nameController.text.isEmpty ||
                                  ageController.text.isEmpty) {
                                return Get.snackbar(
                                    "Validation Error", "Fill all fields",
                                    backgroundColor: Colors.redAccent[200]);
                              }
                              if (nameController.text.isNotEmpty &&
                                  ageController.text.isNotEmpty &&
                                  guardianController
                                      .selectedGender.value.isNotEmpty) {
                                guardianController.registerStudent(
                                  name: nameController.text,
                                  age: ageController.text,
                                  gender:
                                  guardianController.selectedGender.value,
                                  ParentHistory:
                                  guardianController.hasParentHistory.value ,
                                  isDyslexic:
                                  guardianController.isDyslexic.value,
                                );
                              }

                              nameController.clear();ageController.clear();
                            },
                            label: "Register Student",
                            backgroundColor: Colors.teal,
                          ),

                        ],
                      ),
                    ),
                  ),

                  // Student History Tab
                  Obx(() {
                    return ListView.builder(
                      itemCount: guardianController.studentData.length,
                      itemBuilder: (context, index) {
                        final student = guardianController.studentData[index];
                        return Widgets.buildStudentCard(student,controller);
                      },
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
