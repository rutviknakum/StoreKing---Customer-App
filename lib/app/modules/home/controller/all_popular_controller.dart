import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ebazaar/main.dart';
import '../../../../data/server/app_server.dart';
import '../../../../utils/api_list.dart';
import '../model/popular_product.dart';

class AllPopularControler extends GetxController {
  ScrollController scrollController = ScrollController();
  final popularModel = PopularProduct().obs;
  final popularList = <Datum>[].obs;

  int paginate = 1;
  int page = 1;
  int itemPerPage = 8;
  bool hasMoreData = false;

  Future<PopularProduct> fetchPopularProducts() async {
    final response = await AppServer().getRequest(
        endPoint: ApiList.mostPopular(
            paginate.toString(), page.toString(), itemPerPage.toString()),
            headers: box.read('isLogedIn') == false
            ? AppServer.getAuthHeaders()
            : AppServer.getHttpHeadersWithToken());

    if (response.statusCode == 200) {
      final data = response.data;
      popularModel.value = PopularProduct.fromJson(data);
      popularList.value += popularModel.value.data!;
      final meta = data["meta"];
      final lastPage = meta["last_page"];

      if (page <= lastPage) {
        hasMoreData = true;
        page++;
      } else {
        hasMoreData = false;
      }

      return popularModel.value;
    }

    return popularModel.value;
  }

  void loadMoreData() {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        fetchPopularProducts();
      }
    });
  }

  void resetState() {
    popularList.clear();
    page = 1;
    hasMoreData = false;
  }

  @override
  void onInit() {
    fetchPopularProducts();
    super.onInit();
  }
}
