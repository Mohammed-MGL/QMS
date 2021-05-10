import 'package:qms/pages/LoginPage.dart';
import 'package:qms/pages/ServiceCenterDetailsPage.dart';

import '../Model/ServiceCentersModel.dart';
import '../Repo/ServiceCentersRepo.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';

import 'ServiceCenterDetailsController.dart';

class ServiceCentersController extends GetxController {
  ServiceCentersModel scModel = ServiceCentersModel();
  ServiceCentersRepo scRepo = ServiceCentersRepo();
  int pagenum;
  String searchWord;
  bool finish = false;
  bool response = false;
  bool is_Searching = false;
  double containerWidth = 0;
  double containerheight = 0;

  ScrollController scrollController = ScrollController(
    initialScrollOffset: 0.0,
    keepScrollOffset: true,
  );

  TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    pagenum = 1;
    getAllServiceCenters();

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (is_Searching)
          getNextSearchPage();
        else
          getNextPage();
      }
    });
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  void getAllServiceCenters() async {
    scrollController.animateTo(
      0.0,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 300),
    );
    pagenum = 1;
    is_Searching = false;
    var rs = await scRepo.searchForServiceCenters(searchWord, pagenum);
    if (rs[0] == 1) {
      scModel = rs[1];
      response = true;
      if (scModel.next) {
        finish = false;
      } else
        finish = true;
      update();
    } else if (rs[0] == 2) {
      Get.to(() => LoginPage());
    }
  }

  void getNextPage() async {
    if (!finish) {
      pagenum++;
      var rs = await scRepo.searchForServiceCenters(searchWord, pagenum);
      if (rs[0] == 1) {
        ServiceCentersModel temp = rs[1];
        if (scModel.next) {
          scModel.next = temp.next;
          finish = false;
          scModel.results.addAll(temp.results);
          update();
        } else {
          finish = true;
          print("finish");
        }
      } else if (rs[0] == 2) {
        Get.to(() => LoginPage());
      }
    }
  }

  void searchForServiceCenters() async {
    if (searchController.text.length > 0) {
      containerWidth = Get.width * .65;
      containerheight = Get.height * .05;
      update();

      scrollController.animateTo(
        0.0,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );
      pagenum = 1;
      is_Searching = true;
      searchWord = searchController.text;
      var rs = await scRepo.searchForServiceCenters(searchWord, pagenum);
      if (rs[0] == 1) {
        scModel = rs[1];
        response = true;
        if (scModel.next) {
          finish = false;
        } else
          finish = true;
        update();
      } else if (rs[0] == 2) {
        Get.to(() => LoginPage());
      }
    }
  }

  void getNextSearchPage() async {
    if (!finish) {
      pagenum++;
      var rs = await scRepo.searchForServiceCenters(searchWord, pagenum);
      if (rs[0] == 1) {
        ServiceCentersModel temp = rs[1];

        if (scModel.next) {
          scModel.next = temp.next;
          finish = true;
        } else
          finish = false;
        scModel.results.addAll(temp.results);
        update();
      }
    }
  }

  void cancelSearch() {
    searchController.clear();
    containerWidth = 0;
    containerheight = 0;

    getAllServiceCenters();
  }

  void retryGetingServiceCenters() async {
    if (!is_Searching)
      getAllServiceCenters();
    else
      searchForServiceCenters();
  }

  void selectServiceCenter(int scId) {
    Get.find<ServiceCenterDetailsController>().getSCDInfo(scId);
    Get.to(() => ServiceCenterDetailsPage());
  }
}
