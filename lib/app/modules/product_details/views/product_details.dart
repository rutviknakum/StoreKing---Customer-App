import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:ebazaar/app/modules/auth/controller/auth_controler.dart';
import 'package:ebazaar/app/modules/auth/views/sign_in.dart';
import 'package:ebazaar/app/modules/cart/controller/cart_controller.dart';
import 'package:ebazaar/app/modules/category/controller/category_wise_product_controller.dart';
import 'package:ebazaar/app/modules/category/model/category_wise_product.dart'
    as category_product;
import 'package:ebazaar/app/modules/home/model/product_section.dart'
    as section_product;
import 'package:ebazaar/app/modules/home/model/popular_product.dart' as Product;
import 'package:ebazaar/app/modules/navbar/controller/navbar_controller.dart';
import 'package:ebazaar/app/modules/product_details/controller/product_details_controller.dart';
import 'package:ebazaar/app/modules/product_details/model/related_product.dart';
import 'package:ebazaar/app/modules/search/model/all_product.dart';
import 'package:ebazaar/app/modules/wishlist/controller/wishlist_controller.dart';
import 'package:ebazaar/app/modules/wishlist/model/fav_model.dart';
import 'package:ebazaar/main.dart';
import 'package:ebazaar/widgets/custom_snackbar.dart';
import 'package:ebazaar/widgets/devider.dart';
import 'package:ebazaar/widgets/secondary_button.dart';
import 'package:ebazaar/widgets/shimmer/product_details_shimmer.dart';
import 'package:ebazaar/widgets/textwidget.dart';
import '../../../../config/theme/app_color.dart';
import '../../../../utils/svg_icon.dart';
import '../../../../widgets/custom_text.dart';
import '../../promotion/model/promotion_wise_product.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen(
      {super.key,
      this.productModel,
      this.sectionModel,
      this.categoryWiseProduct,
      this.allProductModel,
      this.favoriteItem,
      this.relatedProduct,
      this.product,
      this.data,
      this.individualProduct});
  final category_product.Product? categoryWiseProduct;
  final section_product.Product? productModel;
  final section_product.Datum? sectionModel;
  final Datum? allProductModel;
  final FavoriteItem? favoriteItem;
  final RelatedProduct? relatedProduct;
  final Product.Datum? product;
  final Product.Datum? individualProduct;
  final PromotionProduct? data;

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final navController = Get.put(NavbarController());
  final productDetailsController = Get.put(ProductDetailsController());
  final cartController = Get.find<CartController>();
  final wishlistController = Get.put(WishlistController());
  final authController = Get.put(AuthController());
  final categoryWiseProductController =
      Get.put(CategoryWiseProductController());

  int quantity = 1;
  bool isClicked = false;
  int isSelected = 0;

  @override
  void initState() {
    cartController.numOfItems.value = 1;

    initialCallMethod();

    authController.getSetting();

    super.initState();
  }

  initialCallMethod() async {
    await productDetailsController.fetchProductDetails(
        slug: widget.productModel?.slug ??
            widget.categoryWiseProduct?.slug ??
            widget.allProductModel?.slug ??
            widget.favoriteItem?.slug ??
            widget.individualProduct?.slug ??
            widget.product?.slug ??
            widget.data?.slug ??
            "");

    await productDetailsController.fetchInitialVariation(
        productId: widget.productModel?.id.toString() ??
            widget.categoryWiseProduct?.id.toString() ??
            widget.allProductModel?.id.toString() ??
            widget.favoriteItem?.id.toString() ??
            widget.individualProduct?.id.toString() ??
            widget.product?.id.toString() ??
            widget.data?.id.toString() ??
            "0");
  }

  @override
  void dispose() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      productDetailsController.resetProductState();
    });

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 500.h,
          decoration: BoxDecoration(
              color: AppColor.whiteColor,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25.r),
                  topRight: Radius.circular(25.r))),
          child: GetBuilder<ProductDetailsController>(
            builder: (productDetailsController) {
              return Padding(
                  padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 20.h),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Obx(
                      () => productDetailsController.isLaoding.value == 1
                          ? const ProductDetailsShimmer()
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                  Row(
                                    children: [
                                      CachedNetworkImage(
                                        imageUrl: isClicked
                                            ? productDetailsController
                                                    .productModel
                                                    .value
                                                    .data
                                                    ?.images![isSelected] ??
                                                ""
                                            : productDetailsController
                                                    .productModel
                                                    .value
                                                    .data
                                                    ?.image ??
                                                "",
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          height: 74.h,
                                          width: 70.w,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(16.r),
                                            image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.fill),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 12.w,
                                      ),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            TextWidget(
                                                textAlign: TextAlign.left,
                                                text: productDetailsController
                                                    .productModel
                                                    .value
                                                    .data!
                                                    .name,
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w500,
                                                maxLines: 2,
                                                overflow:
                                                    TextOverflow.ellipsis),
                                            SizedBox(height: 16.h),
                                            SizedBox(
                                              child: TextWidget(
                                                text: productDetailsController
                                                        .productModel
                                                        .value
                                                        .data
                                                        ?.unit ??
                                                    '',
                                                color: AppColor.textColor,
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            SizedBox(height: 8.h),
                                            Row(
                                              children: [
                                                Obx(() {
                                                  if (productDetailsController
                                                          .initialVariationModel
                                                          .value
                                                          .data !=
                                                      null) {
                                                    return CustomText(
                                                      text: productDetailsController.variationProductCurrencyPrice.toString() == ''
                                                          ? productDetailsController
                                                                  .productModel
                                                                  .value
                                                                  .data
                                                                  ?.currencyPrice
                                                                  .toString() ??
                                                              ''
                                                          : productDetailsController
                                                              .variationProductCurrencyPrice
                                                              .toString(),
                                                      color:
                                                          AppColor.primaryColor,
                                                      size: 18.sp,
                                                      weight: FontWeight.w700,
                                                    );
                                                  }
                                                  return const SizedBox();
                                                }),
                                                SizedBox(width: 16.w),
                                                Obx(() {
                                                  if (productDetailsController
                                                              .initialVariationModel
                                                              .value
                                                              .data !=
                                                          null &&
                                                      productDetailsController
                                                              .productModel
                                                              .value
                                                              .data!
                                                              .isOffer ==
                                                          true) {
                                                    return CustomText(
                                                      text: productDetailsController
                                                                  .variationProductOldCurrencyPrice
                                                                  .toString() ==
                                                              ''
                                                          ? productDetailsController
                                                              .productModel
                                                              .value
                                                              .data
                                                              ?.oldCurrencyPrice
                                                              .toString()
                                                          : productDetailsController
                                                              .variationProductOldCurrencyPrice
                                                              .toString(),
                                                      textDecoration:
                                                          TextDecoration
                                                              .lineThrough,
                                                      color: AppColor.black60,
                                                      size: 14.sp,
                                                      weight: FontWeight.w700,
                                                    );
                                                  }

                                                  return const SizedBox();
                                                })
                                              ],
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 15.h),
                                  const DeviderWidget(),
                                  SizedBox(height: 15.h),
                                  productDetailsController.initialIndex.value ==
                                              -1 &&
                                          productDetailsController
                                                  .initialVariationModel
                                                  .value
                                                  .data ==
                                              null
                                      ? const SizedBox()
                                      : Column(
                                          children: [
                                            productDetailsController
                                                            .initialVariationModel
                                                            .value
                                                            .data !=
                                                        null &&
                                                    productDetailsController
                                                            .initialVariationModel
                                                            .value
                                                            .data!
                                                            .length >
                                                        0
                                                ? Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      productDetailsController
                                                                      .initialVariationModel
                                                                      .value
                                                                      .data !=
                                                                  null &&
                                                              productDetailsController
                                                                      .initialVariationModel
                                                                      .value
                                                                      .data!
                                                                      .length >
                                                                  0
                                                          ? CustomText(
                                                              text:
                                                                  '${productDetailsController.initialVariationModel.value.data?[0].productAttributeName.toString().tr}:',
                                                              size: 14.sp,
                                                              weight: FontWeight
                                                                  .w600,
                                                            )
                                                          : SizedBox(),
                                                      productDetailsController
                                                                      .initialVariationModel
                                                                      .value
                                                                      .data !=
                                                                  null &&
                                                              productDetailsController
                                                                      .initialVariationModel
                                                                      .value
                                                                      .data!
                                                                      .length >
                                                                  0
                                                          ? SizedBox(
                                                              height: 8.h)
                                                          : SizedBox(),
                                                      productDetailsController
                                                                      .initialVariationModel
                                                                      .value
                                                                      .data !=
                                                                  null &&
                                                              productDetailsController
                                                                      .initialVariationModel
                                                                      .value
                                                                      .data!
                                                                      .length >
                                                                  0
                                                          ? SizedBox(
                                                              height: 32.h,
                                                              child: ListView
                                                                  .builder(
                                                                      itemCount: productDetailsController
                                                                              .initialVariationModel
                                                                              .value
                                                                              .data
                                                                              ?.length ??
                                                                          0,
                                                                      scrollDirection:
                                                                          Axis
                                                                              .horizontal,
                                                                      itemBuilder:
                                                                          (context,
                                                                              index) {
                                                                        return GestureDetector(
                                                                          onTap:
                                                                              () async {
                                                                            cartController.numOfItems.value =
                                                                                1;

                                                                            productDetailsController.selectedIndex1.value =
                                                                                index;

                                                                            productDetailsController.selectedIndex2.value =
                                                                                -1;
                                                                            productDetailsController.selectedIndex3.value =
                                                                                -1;
                                                                            productDetailsController.selectedIndex4.value =
                                                                                -1;
                                                                            productDetailsController.selectedIndex5.value =
                                                                                -1;
                                                                            productDetailsController.selectedIndex6.value =
                                                                                -1;
                                                                            productDetailsController.selectedIndex7.value =
                                                                                -1;

                                                                            productDetailsController.childrenVariationModel2.value.data?.clear();
                                                                            productDetailsController.childrenVariationModel3.value.data?.clear();
                                                                            productDetailsController.childrenVariationModel4.value.data?.clear();
                                                                            productDetailsController.childrenVariationModel5.value.data?.clear();
                                                                            productDetailsController.childrenVariationModel6.value.data?.clear();

                                                                            if (productDetailsController.initialVariationModel.value.data?[index].sku !=
                                                                                null) {
                                                                              productDetailsController.variationProductId.value = productDetailsController.initialVariationModel.value.data?[index].id.toString() ?? '';
                                                                              productDetailsController.variationProductPrice.value = productDetailsController.initialVariationModel.value.data?[index].price.toString() ?? '';
                                                                              productDetailsController.variationProductCurrencyPrice.value = productDetailsController.initialVariationModel.value.data?[index].currencyPrice.toString() ?? '';
                                                                              productDetailsController.variationProductOldPrice.value = productDetailsController.initialVariationModel.value.data?[index].oldPrice.toString() ?? '';
                                                                              productDetailsController.variationProductOldCurrencyPrice.value = productDetailsController.initialVariationModel.value.data?[index].oldCurrencyPrice.toString() ?? '';
                                                                              productDetailsController.variationsku.value = productDetailsController.initialVariationModel.value.data?[index].sku.toString() ?? '';
                                                                              productDetailsController.variationsStock.value = productDetailsController.initialVariationModel.value.data?[index].stock!.toInt() ?? 0;
                                                                            } else {
                                                                              productDetailsController.variationProductId.value = '';
                                                                              productDetailsController.variationProductPrice.value = '';
                                                                              productDetailsController.variationProductCurrencyPrice.value = '';
                                                                              productDetailsController.variationProductOldPrice.value = '';
                                                                              productDetailsController.variationProductOldCurrencyPrice.value = '';
                                                                              productDetailsController.variationsku.value = '';
                                                                              productDetailsController.variationsStock.value = -1;
                                                                            }

                                                                            if (productDetailsController.initialVariationModel.value.data?[index].sku ==
                                                                                null) {
                                                                              await productDetailsController.fetchChildrenVariation1(initialVariationId: productDetailsController.initialVariationModel.value.data![index].id.toString());
                                                                            }
                                                                          },
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                EdgeInsets.only(right: 8.w),
                                                                            child:
                                                                                Container(
                                                                              decoration: BoxDecoration(
                                                                                color: productDetailsController.selectedIndex1.value == index ? AppColor.primaryColor : AppColor.cartColor,
                                                                                borderRadius: BorderRadius.circular(20.r),
                                                                              ),
                                                                              child: Padding(
                                                                                padding: EdgeInsets.only(left: 12.5.w, right: 12.5.w),
                                                                                child: Center(
                                                                                  child: CustomText(
                                                                                    text: productDetailsController.initialVariationModel.value.data?[index].productAttributeOptionName ?? '',
                                                                                    color: productDetailsController.selectedIndex1.value == index ? Colors.white : Colors.black,
                                                                                    size: 12.sp,
                                                                                    weight: FontWeight.w500,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        );
                                                                      }),
                                                            )
                                                          : SizedBox(),
                                                      productDetailsController
                                                                      .initialVariationModel
                                                                      .value
                                                                      .data !=
                                                                  null &&
                                                              productDetailsController
                                                                      .initialVariationModel
                                                                      .value
                                                                      .data!
                                                                      .length >
                                                                  0
                                                          ? SizedBox(
                                                              height: 24.h)
                                                          : SizedBox(),
                                                    ],
                                                  )
                                                : SizedBox(),
                                            productDetailsController
                                                            .selectedIndex1
                                                            .value ==
                                                        -1 &&
                                                    productDetailsController
                                                            .childrenVariationModel1
                                                            .value
                                                            .data ==
                                                        null
                                                ? const SizedBox()
                                                : Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      productDetailsController
                                                                      .childrenVariationModel1
                                                                      .value
                                                                      .data !=
                                                                  null &&
                                                              productDetailsController
                                                                      .childrenVariationModel1
                                                                      .value
                                                                      .data!
                                                                      .length >
                                                                  0
                                                          ? CustomText(
                                                              text:
                                                                  '${productDetailsController.childrenVariationModel1.value.data?[0].productAttributeName.toString().tr}:',
                                                              size: 14.sp,
                                                              weight: FontWeight
                                                                  .w600,
                                                            )
                                                          : SizedBox(),
                                                      productDetailsController
                                                                      .childrenVariationModel1
                                                                      .value
                                                                      .data !=
                                                                  null &&
                                                              productDetailsController
                                                                      .childrenVariationModel1
                                                                      .value
                                                                      .data!
                                                                      .length >
                                                                  0
                                                          ? SizedBox(
                                                              height: 8.h)
                                                          : SizedBox(),
                                                      productDetailsController
                                                                      .childrenVariationModel1
                                                                      .value
                                                                      .data !=
                                                                  null &&
                                                              productDetailsController
                                                                      .childrenVariationModel1
                                                                      .value
                                                                      .data!
                                                                      .length >
                                                                  0
                                                          ? SizedBox(
                                                              height: 32.h,
                                                              child: ListView
                                                                  .builder(
                                                                      itemCount: productDetailsController
                                                                              .childrenVariationModel1
                                                                              .value
                                                                              .data
                                                                              ?.length ??
                                                                          0,
                                                                      scrollDirection:
                                                                          Axis
                                                                              .horizontal,
                                                                      itemBuilder:
                                                                          (context,
                                                                              index) {
                                                                        return GestureDetector(
                                                                          onTap:
                                                                              () async {
                                                                            cartController.numOfItems.value =
                                                                                1;
                                                                            productDetailsController.selectedIndex2.value =
                                                                                index;

                                                                            productDetailsController.selectedIndex3.value =
                                                                                -1;
                                                                            productDetailsController.selectedIndex4.value =
                                                                                -1;
                                                                            productDetailsController.selectedIndex5.value =
                                                                                -1;
                                                                            productDetailsController.selectedIndex6.value =
                                                                                -1;
                                                                            productDetailsController.selectedIndex7.value =
                                                                                -1;

                                                                            productDetailsController.childrenVariationModel2.value.data?.clear();
                                                                            productDetailsController.childrenVariationModel3.value.data?.clear();
                                                                            productDetailsController.childrenVariationModel4.value.data?.clear();
                                                                            productDetailsController.childrenVariationModel5.value.data?.clear();
                                                                            productDetailsController.childrenVariationModel6.value.data?.clear();

                                                                            if (productDetailsController.childrenVariationModel1.value.data?[index].sku !=
                                                                                null) {
                                                                              productDetailsController.variationProductId.value = productDetailsController.childrenVariationModel1.value.data?[index].id.toString() ?? '';
                                                                              productDetailsController.variationProductPrice.value = productDetailsController.childrenVariationModel1.value.data?[index].price.toString() ?? '';
                                                                              productDetailsController.variationProductCurrencyPrice.value = productDetailsController.childrenVariationModel1.value.data?[index].currencyPrice.toString() ?? '';
                                                                              productDetailsController.variationProductOldPrice.value = productDetailsController.childrenVariationModel1.value.data?[index].oldPrice.toString() ?? '';
                                                                              productDetailsController.variationProductOldCurrencyPrice.value = productDetailsController.childrenVariationModel1.value.data?[index].oldCurrencyPrice.toString() ?? '';
                                                                              productDetailsController.variationsku.value = productDetailsController.childrenVariationModel1.value.data?[index].sku.toString() ?? '';
                                                                              productDetailsController.variationsStock.value = productDetailsController.childrenVariationModel1.value.data?[index].stock!.toInt() ?? 0;
                                                                            } else {
                                                                              productDetailsController.variationProductId.value = '';
                                                                              productDetailsController.variationProductPrice.value = '';
                                                                              productDetailsController.variationProductCurrencyPrice.value = '';
                                                                              productDetailsController.variationProductOldPrice.value = '';
                                                                              productDetailsController.variationProductOldCurrencyPrice.value = '';
                                                                              productDetailsController.variationsku.value = '';
                                                                              productDetailsController.variationsStock.value = -1;
                                                                            }

                                                                            if (productDetailsController.childrenVariationModel1.value.data?[index].sku ==
                                                                                null) {
                                                                              await productDetailsController.fetchChildrenVariation2(initialVariationId: productDetailsController.childrenVariationModel1.value.data![index].id.toString());
                                                                            }
                                                                          },
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                EdgeInsets.only(right: 8.w),
                                                                            child:
                                                                                Container(
                                                                              decoration: BoxDecoration(color: productDetailsController.selectedIndex2.value == index ? AppColor.primaryColor : AppColor.cartColor, borderRadius: BorderRadius.circular(50.r)),
                                                                              child: Padding(
                                                                                padding: EdgeInsets.only(left: 12.5.w, right: 12.5.w),
                                                                                child: Center(
                                                                                  child: CustomText(
                                                                                    text: productDetailsController.childrenVariationModel1.value.data?[index].productAttributeOptionName ?? '',
                                                                                    color: productDetailsController.selectedIndex2.value == index ? Colors.white : Colors.black,
                                                                                    size: 12.sp,
                                                                                    weight: FontWeight.w500,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        );
                                                                      }),
                                                            )
                                                          : SizedBox(),
                                                      productDetailsController
                                                                      .childrenVariationModel1
                                                                      .value
                                                                      .data !=
                                                                  null &&
                                                              productDetailsController
                                                                      .childrenVariationModel1
                                                                      .value
                                                                      .data!
                                                                      .length >
                                                                  0
                                                          ? SizedBox(
                                                              height: 24.h)
                                                          : SizedBox(),
                                                    ],
                                                  ),
                                            productDetailsController
                                                            .selectedIndex2
                                                            .value ==
                                                        -1 &&
                                                    productDetailsController
                                                            .childrenVariationModel2
                                                            .value
                                                            .data ==
                                                        null
                                                ? const SizedBox()
                                                : Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      productDetailsController
                                                                      .childrenVariationModel2
                                                                      .value
                                                                      .data !=
                                                                  null &&
                                                              productDetailsController
                                                                      .childrenVariationModel2
                                                                      .value
                                                                      .data!
                                                                      .length >
                                                                  0
                                                          ? CustomText(
                                                              text:
                                                                  '${productDetailsController.childrenVariationModel2.value.data?[0].productAttributeName.toString().tr ?? ''}:',
                                                              size: 14.sp,
                                                              weight: FontWeight
                                                                  .w600,
                                                            )
                                                          : SizedBox(),
                                                      productDetailsController
                                                                      .childrenVariationModel2
                                                                      .value
                                                                      .data !=
                                                                  null &&
                                                              productDetailsController
                                                                      .childrenVariationModel2
                                                                      .value
                                                                      .data!
                                                                      .length >
                                                                  0
                                                          ? SizedBox(
                                                              height: 8.h)
                                                          : SizedBox(),
                                                      productDetailsController
                                                                      .childrenVariationModel2
                                                                      .value
                                                                      .data !=
                                                                  null &&
                                                              productDetailsController
                                                                      .childrenVariationModel2
                                                                      .value
                                                                      .data!
                                                                      .length >
                                                                  0
                                                          ? SizedBox(
                                                              height: 32.h,
                                                              child: ListView
                                                                  .builder(
                                                                      itemCount: productDetailsController
                                                                              .childrenVariationModel2
                                                                              .value
                                                                              .data
                                                                              ?.length ??
                                                                          0,
                                                                      scrollDirection:
                                                                          Axis
                                                                              .horizontal,
                                                                      itemBuilder:
                                                                          (context,
                                                                              index) {
                                                                        return GestureDetector(
                                                                          onTap:
                                                                              () async {
                                                                            cartController.numOfItems.value =
                                                                                1;
                                                                            productDetailsController.selectedIndex3.value =
                                                                                index;

                                                                            productDetailsController.selectedIndex4.value =
                                                                                -1;
                                                                            productDetailsController.selectedIndex5.value =
                                                                                -1;
                                                                            productDetailsController.selectedIndex6.value =
                                                                                -1;
                                                                            productDetailsController.selectedIndex7.value =
                                                                                -1;

                                                                            productDetailsController.childrenVariationModel3.value.data?.clear();
                                                                            productDetailsController.childrenVariationModel4.value.data?.clear();
                                                                            productDetailsController.childrenVariationModel5.value.data?.clear();
                                                                            productDetailsController.childrenVariationModel6.value.data?.clear();

                                                                            if (productDetailsController.childrenVariationModel2.value.data![index].sku !=
                                                                                null) {
                                                                              productDetailsController.variationProductId.value = productDetailsController.childrenVariationModel2.value.data?[index].id.toString() ?? '';
                                                                              productDetailsController.variationProductPrice.value = productDetailsController.childrenVariationModel2.value.data?[index].price.toString() ?? '';
                                                                              productDetailsController.variationProductCurrencyPrice.value = productDetailsController.childrenVariationModel2.value.data?[index].currencyPrice.toString() ?? '';
                                                                              productDetailsController.variationProductOldPrice.value = productDetailsController.childrenVariationModel2.value.data?[index].oldPrice.toString() ?? '';
                                                                              productDetailsController.variationProductOldCurrencyPrice.value = productDetailsController.childrenVariationModel2.value.data?[index].oldCurrencyPrice.toString() ?? '';
                                                                              productDetailsController.variationsku.value = productDetailsController.childrenVariationModel2.value.data?[index].sku.toString() ?? '';
                                                                              productDetailsController.variationsStock.value = productDetailsController.childrenVariationModel2.value.data?[index].stock!.toInt() ?? 0;
                                                                            } else {
                                                                              productDetailsController.variationProductId.value = '';
                                                                              productDetailsController.variationProductPrice.value = '';
                                                                              productDetailsController.variationProductCurrencyPrice.value = '';
                                                                              productDetailsController.variationProductOldPrice.value = '';
                                                                              productDetailsController.variationProductOldCurrencyPrice.value = '';
                                                                              productDetailsController.variationsku.value = '';
                                                                              productDetailsController.variationsStock.value = -1;
                                                                            }

                                                                            if (productDetailsController.childrenVariationModel2.value.data![index].sku ==
                                                                                null) {
                                                                              await productDetailsController.fetchChildrenVariation3(initialVariationId: productDetailsController.childrenVariationModel2.value.data![index].id.toString());
                                                                            }
                                                                          },
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                EdgeInsets.only(right: 8.w),
                                                                            child:
                                                                                Container(
                                                                              decoration: BoxDecoration(color: productDetailsController.selectedIndex3.value == index ? AppColor.primaryColor : AppColor.cartColor, borderRadius: BorderRadius.circular(50.r)),
                                                                              child: Padding(
                                                                                padding: EdgeInsets.only(left: 12.5.w, right: 12.5.w),
                                                                                child: Center(
                                                                                  child: CustomText(
                                                                                    text: productDetailsController.childrenVariationModel2.value.data?[index].productAttributeOptionName ?? '',
                                                                                    color: productDetailsController.selectedIndex3.value == index ? Colors.white : Colors.black,
                                                                                    size: 12.sp,
                                                                                    weight: FontWeight.w500,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        );
                                                                      }),
                                                            )
                                                          : SizedBox(),
                                                      productDetailsController
                                                                      .childrenVariationModel2
                                                                      .value
                                                                      .data !=
                                                                  null &&
                                                              productDetailsController
                                                                      .childrenVariationModel2
                                                                      .value
                                                                      .data!
                                                                      .length >
                                                                  0
                                                          ? SizedBox(
                                                              height: 24.h)
                                                          : SizedBox(),
                                                    ],
                                                  ),
                                            productDetailsController
                                                            .selectedIndex3
                                                            .value ==
                                                        -1 &&
                                                    productDetailsController
                                                            .childrenVariationModel3
                                                            .value
                                                            .data ==
                                                        null
                                                ? const SizedBox()
                                                : Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      productDetailsController
                                                                      .childrenVariationModel3
                                                                      .value
                                                                      .data !=
                                                                  null &&
                                                              productDetailsController
                                                                      .childrenVariationModel3
                                                                      .value
                                                                      .data!
                                                                      .length >
                                                                  0
                                                          ? CustomText(
                                                              text:
                                                                  '${productDetailsController.childrenVariationModel3.value.data?[0].productAttributeName.toString().tr ?? ''}:',
                                                              size: 14.sp,
                                                              weight: FontWeight
                                                                  .w600,
                                                            )
                                                          : SizedBox(),
                                                      productDetailsController
                                                                      .childrenVariationModel3
                                                                      .value
                                                                      .data !=
                                                                  null &&
                                                              productDetailsController
                                                                      .childrenVariationModel3
                                                                      .value
                                                                      .data!
                                                                      .length >
                                                                  0
                                                          ? SizedBox(
                                                              height: 8.h)
                                                          : SizedBox(),
                                                      productDetailsController
                                                                      .childrenVariationModel3
                                                                      .value
                                                                      .data !=
                                                                  null &&
                                                              productDetailsController
                                                                      .childrenVariationModel3
                                                                      .value
                                                                      .data!
                                                                      .length >
                                                                  0
                                                          ? SizedBox(
                                                              height: 32.h,
                                                              child: ListView
                                                                  .builder(
                                                                      itemCount: productDetailsController
                                                                              .childrenVariationModel3
                                                                              .value
                                                                              .data
                                                                              ?.length ??
                                                                          0,
                                                                      scrollDirection:
                                                                          Axis
                                                                              .horizontal,
                                                                      itemBuilder:
                                                                          (context,
                                                                              index) {
                                                                        return GestureDetector(
                                                                          onTap:
                                                                              () async {
                                                                            cartController.numOfItems.value =
                                                                                1;
                                                                            productDetailsController.selectedIndex4.value =
                                                                                index;

                                                                            productDetailsController.selectedIndex5.value =
                                                                                -1;
                                                                            productDetailsController.selectedIndex6.value =
                                                                                -1;
                                                                            productDetailsController.selectedIndex7.value =
                                                                                -1;

                                                                            productDetailsController.childrenVariationModel4.value.data?.clear();
                                                                            productDetailsController.childrenVariationModel5.value.data?.clear();
                                                                            productDetailsController.childrenVariationModel6.value.data?.clear();

                                                                            if (productDetailsController.childrenVariationModel3.value.data![index].sku !=
                                                                                null) {
                                                                              productDetailsController.variationProductId.value = productDetailsController.childrenVariationModel3.value.data?[index].id.toString() ?? '';
                                                                              productDetailsController.variationProductPrice.value = productDetailsController.childrenVariationModel3.value.data?[index].price.toString() ?? '';
                                                                              productDetailsController.variationProductCurrencyPrice.value = productDetailsController.childrenVariationModel3.value.data?[index].currencyPrice.toString() ?? '';
                                                                              productDetailsController.variationProductOldPrice.value = productDetailsController.childrenVariationModel3.value.data?[index].oldPrice.toString() ?? '';
                                                                              productDetailsController.variationProductOldCurrencyPrice.value = productDetailsController.childrenVariationModel3.value.data?[index].oldCurrencyPrice.toString() ?? '';
                                                                              productDetailsController.variationsku.value = productDetailsController.childrenVariationModel3.value.data?[index].sku.toString() ?? '';
                                                                              productDetailsController.variationsStock.value = productDetailsController.childrenVariationModel3.value.data?[index].stock!.toInt() ?? 0;
                                                                            } else {
                                                                              productDetailsController.variationProductId.value = '';
                                                                              productDetailsController.variationProductPrice.value = '';
                                                                              productDetailsController.variationProductCurrencyPrice.value = '';
                                                                              productDetailsController.variationProductOldPrice.value = '';
                                                                              productDetailsController.variationProductOldCurrencyPrice.value = '';
                                                                              productDetailsController.variationsku.value = '';
                                                                              productDetailsController.variationsStock.value = -1;
                                                                            }

                                                                            if (productDetailsController.childrenVariationModel3.value.data?[index].sku ==
                                                                                null) {
                                                                              await productDetailsController.fetchChildrenVariation4(initialVariationId: productDetailsController.childrenVariationModel3.value.data![index].id.toString());
                                                                            }
                                                                          },
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                EdgeInsets.only(right: 8.w),
                                                                            child:
                                                                                Container(
                                                                              decoration: BoxDecoration(color: productDetailsController.selectedIndex4.value == index ? AppColor.primaryColor : AppColor.cartColor, borderRadius: BorderRadius.circular(50.r)),
                                                                              child: Padding(
                                                                                padding: EdgeInsets.only(left: 12.5.w, right: 12.5.w),
                                                                                child: Center(
                                                                                  child: CustomText(
                                                                                    text: productDetailsController.childrenVariationModel3.value.data?[index].productAttributeOptionName ?? '',
                                                                                    color: productDetailsController.selectedIndex4.value == index ? Colors.white : Colors.black,
                                                                                    size: 12.sp,
                                                                                    weight: FontWeight.w500,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        );
                                                                      }),
                                                            )
                                                          : SizedBox(),
                                                      productDetailsController
                                                                      .childrenVariationModel3
                                                                      .value
                                                                      .data !=
                                                                  null &&
                                                              productDetailsController
                                                                      .childrenVariationModel3
                                                                      .value
                                                                      .data!
                                                                      .length >
                                                                  0
                                                          ? SizedBox(
                                                              height: 24.h)
                                                          : SizedBox(),
                                                    ],
                                                  ),
                                            productDetailsController
                                                            .selectedIndex4
                                                            .value ==
                                                        -1 &&
                                                    productDetailsController
                                                            .childrenVariationModel4
                                                            .value
                                                            .data ==
                                                        null
                                                ? const SizedBox()
                                                : Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      productDetailsController
                                                                      .childrenVariationModel4
                                                                      .value
                                                                      .data !=
                                                                  null &&
                                                              productDetailsController
                                                                      .childrenVariationModel4
                                                                      .value
                                                                      .data!
                                                                      .length >
                                                                  0
                                                          ? CustomText(
                                                              text:
                                                                  '${productDetailsController.childrenVariationModel4.value.data?[0].productAttributeName.toString().tr ?? ''}:',
                                                              size: 14.sp,
                                                              weight: FontWeight
                                                                  .w600,
                                                            )
                                                          : SizedBox(),
                                                      productDetailsController
                                                                      .childrenVariationModel4
                                                                      .value
                                                                      .data !=
                                                                  null &&
                                                              productDetailsController
                                                                      .childrenVariationModel4
                                                                      .value
                                                                      .data!
                                                                      .length >
                                                                  0
                                                          ? SizedBox(
                                                              height: 8.h)
                                                          : SizedBox(),
                                                      productDetailsController
                                                                      .childrenVariationModel4
                                                                      .value
                                                                      .data !=
                                                                  null &&
                                                              productDetailsController
                                                                      .childrenVariationModel4
                                                                      .value
                                                                      .data!
                                                                      .length >
                                                                  0
                                                          ? SizedBox(
                                                              height: 32.h,
                                                              child: ListView
                                                                  .builder(
                                                                      itemCount: productDetailsController
                                                                              .childrenVariationModel4
                                                                              .value
                                                                              .data
                                                                              ?.length ??
                                                                          0,
                                                                      scrollDirection:
                                                                          Axis
                                                                              .horizontal,
                                                                      itemBuilder:
                                                                          (context,
                                                                              index) {
                                                                        return GestureDetector(
                                                                          onTap:
                                                                              () async {
                                                                            cartController.numOfItems.value =
                                                                                1;
                                                                            productDetailsController.selectedIndex5.value =
                                                                                index;

                                                                            productDetailsController.selectedIndex6.value =
                                                                                -1;
                                                                            productDetailsController.selectedIndex7.value =
                                                                                -1;

                                                                            productDetailsController.childrenVariationModel5.value.data?.clear();
                                                                            productDetailsController.childrenVariationModel6.value.data?.clear();

                                                                            if (productDetailsController.childrenVariationModel4.value.data![index].sku !=
                                                                                null) {
                                                                              productDetailsController.variationProductId.value = productDetailsController.childrenVariationModel4.value.data?[index].id.toString() ?? '';
                                                                              productDetailsController.variationProductPrice.value = productDetailsController.childrenVariationModel4.value.data?[index].price.toString() ?? '';
                                                                              productDetailsController.variationProductCurrencyPrice.value = productDetailsController.childrenVariationModel4.value.data?[index].currencyPrice.toString() ?? '';
                                                                              productDetailsController.variationProductOldPrice.value = productDetailsController.childrenVariationModel4.value.data?[index].oldPrice.toString() ?? '';
                                                                              productDetailsController.variationProductOldCurrencyPrice.value = productDetailsController.childrenVariationModel4.value.data?[index].oldCurrencyPrice.toString() ?? '';
                                                                              productDetailsController.variationsku.value = productDetailsController.childrenVariationModel4.value.data?[index].sku.toString() ?? '';
                                                                              productDetailsController.variationsStock.value = productDetailsController.childrenVariationModel4.value.data?[index].stock!.toInt() ?? 0;
                                                                            } else {
                                                                              productDetailsController.variationProductId.value = '';
                                                                              productDetailsController.variationProductPrice.value = '';
                                                                              productDetailsController.variationProductCurrencyPrice.value = '';
                                                                              productDetailsController.variationProductOldPrice.value = '';
                                                                              productDetailsController.variationProductOldCurrencyPrice.value = '';
                                                                              productDetailsController.variationsku.value = '';
                                                                              productDetailsController.variationsStock.value = -1;
                                                                            }

                                                                            if (productDetailsController.childrenVariationModel4.value.data![index].sku ==
                                                                                null) {
                                                                              await productDetailsController.fetchChildrenVariation5(initialVariationId: productDetailsController.childrenVariationModel4.value.data![index].id.toString());
                                                                            }
                                                                          },
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                EdgeInsets.only(right: 8.w),
                                                                            child:
                                                                                Container(
                                                                              decoration: BoxDecoration(color: productDetailsController.selectedIndex5.value == index ? AppColor.primaryColor : AppColor.cartColor, borderRadius: BorderRadius.circular(50.r)),
                                                                              child: Padding(
                                                                                padding: EdgeInsets.only(left: 12.5.w, right: 12.5.w),
                                                                                child: Center(
                                                                                  child: CustomText(
                                                                                    text: productDetailsController.childrenVariationModel4.value.data?[index].productAttributeOptionName ?? '',
                                                                                    color: productDetailsController.selectedIndex5.value == index ? Colors.white : Colors.black,
                                                                                    size: 12.sp,
                                                                                    weight: FontWeight.w500,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        );
                                                                      }),
                                                            )
                                                          : SizedBox(),
                                                      productDetailsController
                                                                      .childrenVariationModel4
                                                                      .value
                                                                      .data !=
                                                                  null &&
                                                              productDetailsController
                                                                      .childrenVariationModel4
                                                                      .value
                                                                      .data!
                                                                      .length >
                                                                  0
                                                          ? SizedBox(
                                                              height: 24.h)
                                                          : SizedBox(),
                                                    ],
                                                  ),
                                            productDetailsController
                                                            .selectedIndex5
                                                            .value ==
                                                        -1 &&
                                                    productDetailsController
                                                            .childrenVariationModel5
                                                            .value
                                                            .data ==
                                                        null
                                                ? const SizedBox()
                                                : Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      productDetailsController
                                                                      .childrenVariationModel5
                                                                      .value
                                                                      .data !=
                                                                  null &&
                                                              productDetailsController
                                                                      .childrenVariationModel5
                                                                      .value
                                                                      .data!
                                                                      .length >
                                                                  0
                                                          ? CustomText(
                                                              text:
                                                                  '${productDetailsController.childrenVariationModel5.value.data?[0].productAttributeName.toString().tr ?? ''}:',
                                                              size: 15.sp,
                                                              weight: FontWeight
                                                                  .w600,
                                                            )
                                                          : SizedBox(),
                                                      productDetailsController
                                                                      .childrenVariationModel5
                                                                      .value
                                                                      .data !=
                                                                  null &&
                                                              productDetailsController
                                                                      .childrenVariationModel5
                                                                      .value
                                                                      .data!
                                                                      .length >
                                                                  0
                                                          ? SizedBox(
                                                              height: 8.h)
                                                          : SizedBox(),
                                                      productDetailsController
                                                                      .childrenVariationModel5
                                                                      .value
                                                                      .data !=
                                                                  null &&
                                                              productDetailsController
                                                                      .childrenVariationModel5
                                                                      .value
                                                                      .data!
                                                                      .length >
                                                                  0
                                                          ? SizedBox(
                                                              height: 32.h,
                                                              child: ListView
                                                                  .builder(
                                                                      itemCount: productDetailsController
                                                                              .childrenVariationModel5
                                                                              .value
                                                                              .data
                                                                              ?.length ??
                                                                          0,
                                                                      scrollDirection:
                                                                          Axis
                                                                              .horizontal,
                                                                      itemBuilder:
                                                                          (context,
                                                                              index) {
                                                                        return GestureDetector(
                                                                          onTap:
                                                                              () async {
                                                                            cartController.numOfItems.value =
                                                                                1;
                                                                            productDetailsController.selectedIndex6.value =
                                                                                index;

                                                                            productDetailsController.selectedIndex7.value =
                                                                                -1;

                                                                            productDetailsController.childrenVariationModel6.value.data?.clear();

                                                                            if (productDetailsController.childrenVariationModel5.value.data![index].sku !=
                                                                                null) {
                                                                              productDetailsController.variationProductId.value = productDetailsController.childrenVariationModel5.value.data?[index].id.toString() ?? '';
                                                                              productDetailsController.variationProductPrice.value = productDetailsController.childrenVariationModel5.value.data?[index].price.toString() ?? '';
                                                                              productDetailsController.variationProductCurrencyPrice.value = productDetailsController.childrenVariationModel5.value.data?[index].currencyPrice.toString() ?? '';
                                                                              productDetailsController.variationProductOldPrice.value = productDetailsController.childrenVariationModel5.value.data?[index].oldPrice.toString() ?? '';
                                                                              productDetailsController.variationProductOldCurrencyPrice.value = productDetailsController.childrenVariationModel5.value.data?[index].oldCurrencyPrice.toString() ?? '';
                                                                              productDetailsController.variationsku.value = productDetailsController.childrenVariationModel5.value.data?[index].sku.toString() ?? '';
                                                                              productDetailsController.variationsStock.value = productDetailsController.childrenVariationModel5.value.data?[index].stock!.toInt() ?? 0;
                                                                            } else {
                                                                              productDetailsController.variationProductId.value = '';
                                                                              productDetailsController.variationProductPrice.value = '';
                                                                              productDetailsController.variationProductCurrencyPrice.value = '';
                                                                              productDetailsController.variationProductOldPrice.value = '';
                                                                              productDetailsController.variationProductOldCurrencyPrice.value = '';
                                                                              productDetailsController.variationsku.value = '';
                                                                              productDetailsController.variationsStock.value = -1;
                                                                            }

                                                                            if (productDetailsController.childrenVariationModel5.value.data![index].sku ==
                                                                                null) {
                                                                              await productDetailsController.fetchChildrenVariation6(initialVariationId: productDetailsController.childrenVariationModel5.value.data![index].id.toString());
                                                                            }
                                                                          },
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                EdgeInsets.only(right: 8.w),
                                                                            child:
                                                                                Container(
                                                                              decoration: BoxDecoration(color: productDetailsController.selectedIndex6.value == index ? AppColor.primaryColor : AppColor.cartColor, borderRadius: BorderRadius.circular(50.r)),
                                                                              child: Padding(
                                                                                padding: EdgeInsets.only(left: 12.5.w, right: 12.5.w),
                                                                                child: Center(
                                                                                  child: CustomText(
                                                                                    text: productDetailsController.childrenVariationModel5.value.data?[index].productAttributeOptionName ?? '',
                                                                                    color: productDetailsController.selectedIndex6.value == index ? Colors.white : Colors.black,
                                                                                    size: 12.sp,
                                                                                    weight: FontWeight.w500,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        );
                                                                      }),
                                                            )
                                                          : SizedBox(),
                                                      productDetailsController
                                                                      .childrenVariationModel5
                                                                      .value
                                                                      .data !=
                                                                  null &&
                                                              productDetailsController
                                                                      .childrenVariationModel5
                                                                      .value
                                                                      .data!
                                                                      .length >
                                                                  0
                                                          ? SizedBox(
                                                              height: 24.h)
                                                          : SizedBox(),
                                                    ],
                                                  ),
                                            productDetailsController
                                                            .selectedIndex6
                                                            .value ==
                                                        -1 &&
                                                    productDetailsController
                                                            .childrenVariationModel6
                                                            .value
                                                            .data ==
                                                        null
                                                ? const SizedBox()
                                                : Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      productDetailsController
                                                                      .childrenVariationModel6
                                                                      .value
                                                                      .data !=
                                                                  null &&
                                                              productDetailsController
                                                                      .childrenVariationModel6
                                                                      .value
                                                                      .data!
                                                                      .length >
                                                                  0
                                                          ? CustomText(
                                                              text:
                                                                  '${productDetailsController.childrenVariationModel6.value.data?[0].productAttributeName.toString().tr ?? ''}:',
                                                              size: 14.sp,
                                                              weight: FontWeight
                                                                  .w600,
                                                            )
                                                          : SizedBox(),
                                                      productDetailsController
                                                                      .childrenVariationModel6
                                                                      .value
                                                                      .data !=
                                                                  null &&
                                                              productDetailsController
                                                                      .childrenVariationModel6
                                                                      .value
                                                                      .data!
                                                                      .length >
                                                                  0
                                                          ? SizedBox(
                                                              height: 8.h)
                                                          : SizedBox(),
                                                      productDetailsController
                                                                      .childrenVariationModel6
                                                                      .value
                                                                      .data !=
                                                                  null &&
                                                              productDetailsController
                                                                      .childrenVariationModel6
                                                                      .value
                                                                      .data!
                                                                      .length >
                                                                  0
                                                          ? SizedBox(
                                                              height: 32.h,
                                                              child: ListView
                                                                  .builder(
                                                                      itemCount: productDetailsController
                                                                              .childrenVariationModel6
                                                                              .value
                                                                              .data
                                                                              ?.length ??
                                                                          0,
                                                                      scrollDirection:
                                                                          Axis
                                                                              .horizontal,
                                                                      itemBuilder:
                                                                          (context,
                                                                              index) {
                                                                        return GestureDetector(
                                                                          onTap:
                                                                              () async {
                                                                            cartController.numOfItems.value =
                                                                                1;

                                                                            productDetailsController.selectedIndex7.value =
                                                                                index;

                                                                            if (productDetailsController.childrenVariationModel6.value.data?[index].sku !=
                                                                                null) {
                                                                              productDetailsController.variationProductId.value = productDetailsController.childrenVariationModel6.value.data?[index].id.toString() ?? '';
                                                                              productDetailsController.variationProductPrice.value = productDetailsController.childrenVariationModel6.value.data?[index].price.toString() ?? '';
                                                                              productDetailsController.variationProductCurrencyPrice.value = productDetailsController.childrenVariationModel6.value.data?[index].currencyPrice.toString() ?? '';
                                                                              productDetailsController.variationProductOldPrice.value = productDetailsController.childrenVariationModel6.value.data?[index].oldPrice.toString() ?? '';
                                                                              productDetailsController.variationProductOldCurrencyPrice.value = productDetailsController.childrenVariationModel6.value.data?[index].oldCurrencyPrice.toString() ?? '';
                                                                              productDetailsController.variationsku.value = productDetailsController.childrenVariationModel6.value.data?[index].sku.toString() ?? '';
                                                                              productDetailsController.variationsStock.value = productDetailsController.childrenVariationModel6.value.data?[index].stock!.toInt() ?? 0;
                                                                            } else {
                                                                              productDetailsController.variationProductId.value = '';
                                                                              productDetailsController.variationProductPrice.value = '';
                                                                              productDetailsController.variationProductCurrencyPrice.value = '';
                                                                              productDetailsController.variationProductOldPrice.value = '';
                                                                              productDetailsController.variationProductOldCurrencyPrice.value = '';
                                                                              productDetailsController.variationsku.value = '';
                                                                              productDetailsController.variationsStock.value = -1;
                                                                            }
                                                                          },
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                EdgeInsets.only(right: 8.w),
                                                                            child:
                                                                                Container(
                                                                              decoration: BoxDecoration(color: productDetailsController.selectedIndex7.value == index ? AppColor.primaryColor : AppColor.cartColor, borderRadius: BorderRadius.circular(50.r)),
                                                                              child: Padding(
                                                                                padding: EdgeInsets.only(left: 12.5.w, right: 12.5.w),
                                                                                child: Center(
                                                                                  child: CustomText(
                                                                                    text: productDetailsController.childrenVariationModel5.value.data![index].productAttributeOptionName,
                                                                                    color: productDetailsController.selectedIndex7.value == index ? Colors.white : Colors.black,
                                                                                    size: 12.sp,
                                                                                    weight: FontWeight.w500,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        );
                                                                      }),
                                                            )
                                                          : SizedBox(),
                                                      productDetailsController
                                                                      .childrenVariationModel5
                                                                      .value
                                                                      .data !=
                                                                  null &&
                                                              productDetailsController
                                                                      .childrenVariationModel5
                                                                      .value
                                                                      .data!
                                                                      .length >
                                                                  0
                                                          ? SizedBox(
                                                              height: 24.h)
                                                          : SizedBox(),
                                                    ],
                                                  ),
                                          ],
                                        ),
                                  CustomText(
                                    text: "QUANTITY".tr,
                                    size: 14.sp,
                                    weight: FontWeight.w600,
                                  ),
                                  SizedBox(height: 8.h),
                                  Row(
                                    children: [
                                      Container(
                                        width: 99.w,
                                        height: 36.h,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20.r),
                                          color: AppColor.cartColor,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            GestureDetector(
                                                onTap: () {
                                                  // Variation is not empty
                                                  if (productDetailsController
                                                          .initialVariationModel
                                                          .value
                                                          .data!
                                                          .isNotEmpty ||
                                                      productDetailsController
                                                              .initialVariationModel
                                                              .value
                                                              .data!
                                                              .length >
                                                          0) {
                                                    if (productDetailsController
                                                            .variationsStock
                                                            .value <
                                                        0) {
                                                    } else {
                                                      if (cartController
                                                              .numOfItems
                                                              .value >
                                                          1) {
                                                        cartController
                                                            .numOfItems.value--;
                                                      } else {}
                                                    }
                                                  }
                                                  // Initial Variation null
                                                  else {
                                                    if (productDetailsController
                                                                .productModel
                                                                .value
                                                                .data!
                                                                .stock! >
                                                            1 &&
                                                        cartController
                                                                .numOfItems
                                                                .value >
                                                            1) {
                                                      cartController
                                                          .numOfItems.value--;
                                                    } else {}
                                                  }
                                                },
                                                child:

                                                    // Intial variation null
                                                    productDetailsController
                                                                    .initialVariationModel
                                                                    .value
                                                                    .data ==
                                                                null ||
                                                            productDetailsController
                                                                .initialVariationModel
                                                                .value
                                                                .data!
                                                                .isEmpty
                                                        ? productDetailsController
                                                                        .productModel
                                                                        .value
                                                                        .data!
                                                                        .stock! >
                                                                    1 &&
                                                                cartController.numOfItems.value >
                                                                    1
                                                            ?
                                                            // decrement active
                                                            SvgPicture.asset(
                                                                SvgIcon
                                                                    .decrement,
                                                                color: Colors
                                                                    .black,
                                                                height: 20.h,
                                                                width: 20.w)
                                                            :

                                                            // decrement inActive
                                                            SvgPicture.asset(
                                                                SvgIcon.decrement,
                                                                color: Colors.grey,
                                                                height: 20.h,
                                                                width: 20.w)
                                                        :

                                                        // Intial variation Not null

                                                        productDetailsController.variationsStock.value != -1
                                                            ? cartController.numOfItems.value == 1 || productDetailsController.variationsStock.value == 1
                                                                ? SvgPicture.asset(SvgIcon.decrement, color: Colors.grey, height: 20.h, width: 20.w)
                                                                : SvgPicture.asset(SvgIcon.decrement, height: 20.h, width: 20.w)
                                                            : SvgPicture.asset(SvgIcon.decrement, height: 20.h, width: 20.w, color: Colors.grey)),
                                            Obx(
                                              () => CustomText(
                                                  text: cartController
                                                      .numOfItems.value
                                                      .toString(),
                                                  size: 18.sp,
                                                  weight: FontWeight.w600),
                                            ),
                                            GestureDetector(
                                                onTap: () {
                                                  // initial variaiton Not null

                                                  if (productDetailsController
                                                              .initialVariationModel
                                                              .value
                                                              .data !=
                                                          null ||
                                                      productDetailsController
                                                          .initialVariationModel
                                                          .value
                                                          .data!
                                                          .isNotEmpty) {
                                                    if (productDetailsController
                                                            .variationsStock
                                                            .value <
                                                        0) {
                                                    } else {
                                                      if (cartController
                                                              .numOfItems
                                                              .value <
                                                          productDetailsController
                                                              .variationsStock
                                                              .value) {
                                                        if (cartController
                                                                .numOfItems
                                                                .value <
                                                            productDetailsController
                                                                .productModel
                                                                .value
                                                                .data!
                                                                .maximumPurchaseQuantity!) {
                                                          cartController
                                                              .numOfItems
                                                              .value++;
                                                        } else {
                                                          customSnackbar(
                                                              "INFO".tr,
                                                              "MAXIMUM_PURCHASE_QUANTITY_LIMIT_EXCEEDED"
                                                                  .tr,
                                                              AppColor
                                                                  .redColor);
                                                        }
                                                      } else {}
                                                    }
                                                  }

                                                  // initial variaiton null

                                                  if (productDetailsController
                                                          .productModel
                                                          .value
                                                          .data!
                                                          .stock! >
                                                      0) {
                                                    // If numOfitem is less than stock - Increment

                                                    if (cartController
                                                            .numOfItems.value <
                                                        productDetailsController
                                                            .productModel
                                                            .value
                                                            .data!
                                                            .stock!) {
                                                      if (cartController
                                                              .numOfItems
                                                              .value <
                                                          productDetailsController
                                                              .productModel
                                                              .value
                                                              .data!
                                                              .maximumPurchaseQuantity!) {
                                                        cartController
                                                            .numOfItems.value++;
                                                      } else {
                                                        customSnackbar(
                                                            "INFO".tr,
                                                            "MAXIMUM_PURCHASE_QUANTITY_LIMIT_EXCEEDED"
                                                                .tr,
                                                            AppColor.redColor);
                                                      }
                                                    }
                                                  }
                                                },
                                                child:

                                                    // Intial variation null
                                                    productDetailsController
                                                                    .initialVariationModel
                                                                    .value
                                                                    .data ==
                                                                null ||
                                                            productDetailsController
                                                                .initialVariationModel
                                                                .value
                                                                .data!
                                                                .isEmpty
                                                        ? productDetailsController
                                                                        .productModel
                                                                        .value
                                                                        .data!
                                                                        .stock! >
                                                                    1 &&
                                                                cartController.numOfItems.value <
                                                                    productDetailsController
                                                                        .productModel
                                                                        .value
                                                                        .data!
                                                                        .stock!
                                                            ?
                                                            // Iccrement active
                                                            SvgPicture.asset(SvgIcon.increment,
                                                                color: AppColor
                                                                    .primaryColor,
                                                                height: 20.h,
                                                                width: 20.w)
                                                            :

                                                            // Increment inActive
                                                            SvgPicture.asset(
                                                                SvgIcon.increment,
                                                                height: 20.h,
                                                                width: 20.w,
                                                                color: Colors.grey)
                                                        : productDetailsController.variationsStock.value != -1
                                                            ? cartController.numOfItems.value == productDetailsController.variationsStock.value || productDetailsController.variationsStock.value == 0
                                                                ? SvgPicture.asset(SvgIcon.increment, color: Colors.grey, height: 20.h, width: 20.w)
                                                                : SvgPicture.asset(SvgIcon.increment, color: AppColor.primaryColor, height: 20.h, width: 20.w)
                                                            : SvgPicture.asset(SvgIcon.increment, height: 20.h, width: 20.w, color: Colors.grey))
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 8.w),
                                      Obx(
                                        () => productDetailsController
                                                        .initialVariationModel
                                                        .value
                                                        .data ==
                                                    null ||
                                                productDetailsController
                                                    .initialVariationModel
                                                    .value
                                                    .data!
                                                    .isEmpty
                                            ? productDetailsController
                                                        .productModel
                                                        .value
                                                        .data!
                                                        .stock! >
                                                    0
                                                ? Row(
                                                    children: [
                                                      TextWidget(
                                                        text: "Available:".tr,
                                                        fontSize: 14.sp,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                      TextWidget(
                                                          text:
                                                              " (${productDetailsController.productModel.value.data?.stock}) ",
                                                          fontSize: 16.sp,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                      TextWidget(
                                                        text:
                                                            productDetailsController
                                                                .productModel
                                                                .value
                                                                .data
                                                                ?.unit
                                                                ?.toLowerCase(),
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 14.sp,
                                                      )
                                                    ],
                                                  )
                                                : productDetailsController
                                                            .productModel
                                                            .value
                                                            .data!
                                                            .stock! ==
                                                        0
                                                    ? TextWidget(
                                                        text: "Stock Out".tr,
                                                        color:
                                                            AppColor.redColor,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 14.sp,
                                                      )
                                                    : const SizedBox()

                                            // inital variation not null

                                            : productDetailsController
                                                        .variationsStock.value >
                                                    0
                                                ? Row(
                                                    children: [
                                                      TextWidget(
                                                        text: "Available:".tr,
                                                        fontSize: 14.sp,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                      TextWidget(
                                                          text:
                                                              " (${productDetailsController.variationsStock.value}) ",
                                                          fontSize: 16.sp,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                      TextWidget(
                                                        text:
                                                            productDetailsController
                                                                .productModel
                                                                .value
                                                                .data
                                                                ?.unit
                                                                ?.toLowerCase(),
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 14.sp,
                                                      )
                                                    ],
                                                  )
                                                : productDetailsController
                                                            .variationsStock
                                                            .value ==
                                                        0
                                                    ? TextWidget(
                                                        text: "Stock Out".tr,
                                                        color:
                                                            AppColor.redColor,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 14.sp,
                                                      )
                                                    : const SizedBox(),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 32.h),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Obx(
                                        () => SecondaryButton(
                                            height: 48.h,
                                            width: 165.w,
                                            icon: SvgIcon.bag,
                                            text: "ADD_TO_CART".tr,
                                            buttonColor: productDetailsController
                                                            .initialVariationModel
                                                            .value
                                                            .data ==
                                                        null ||
                                                    productDetailsController
                                                        .initialVariationModel
                                                        .value
                                                        .data!
                                                        .isEmpty
                                                ? productDetailsController
                                                            .productModel
                                                            .value
                                                            .data!
                                                            .stock! >
                                                        0
                                                    ? AppColor.primaryColor
                                                    : AppColor.grayColor

                                                // inital variation not null

                                                : productDetailsController
                                                            .variationsStock
                                                            .value >
                                                        0
                                                    ? AppColor.primaryColor
                                                    : AppColor.grayColor,
                                            onTap: () async {
                                              if (productDetailsController
                                                          .initialVariationModel
                                                          .value
                                                          .data !=
                                                      null &&
                                                  productDetailsController
                                                      .initialVariationModel
                                                      .value
                                                      .data!
                                                      .isNotEmpty) {
                                                if (productDetailsController
                                                        .variationsStock.value >
                                                    0) {
                                                  await productDetailsController
                                                      .finalVariation(
                                                          id: productDetailsController
                                                              .variationProductId
                                                              .toString());
                                                  cartController
                                                          .totalIndividualProductTax =
                                                      0.0;
                                                  productDetailsController
                                                      .productModel
                                                      .value
                                                      .data!
                                                      .taxes!
                                                      .map((e) {
                                                    cartController
                                                            .totalIndividualProductTax +=
                                                        double.parse(e.taxRate
                                                            .toString());
                                                  }).toList();

                                                  var taxMap =
                                                      productDetailsController
                                                          .productModel
                                                          .value
                                                          .data!
                                                          .taxes!
                                                          .map((e) {
                                                    return {
                                                      "id": e.id!.toInt(),
                                                      "name": e.name.toString(),
                                                      "code": e.code.toString(),
                                                      "tax_rate":
                                                          double.tryParse(e
                                                              .taxRate
                                                              .toString()),
                                                      'tax_amount':
                                                          double.tryParse(
                                                              cartController
                                                                  .totalTax
                                                                  .toString()),
                                                    };
                                                  }).toList();

                                                  cartController.addItem(
                                                      variationStock: productDetailsController.variationsStock.value
                                                          .toInt(),
                                                      product: productDetailsController
                                                          .productModel.value,
                                                      variationId: productDetailsController.initialVariationModel.value.data == null ||
                                                              productDetailsController
                                                                  .initialVariationModel
                                                                  .value
                                                                  .data!
                                                                  .isEmpty
                                                          ? 0
                                                          : int.parse(productDetailsController
                                                              .variationProductId
                                                              .value),
                                                      shippingAmount: authController.settingModel!.data!.shippingSetupMethod.toString() == "5" && productDetailsController.productModel.value.data?.shipping?.shippingType.toString() == "5"
                                                          ? "0"
                                                          : productDetailsController
                                                              .productModel
                                                              .value
                                                              .data
                                                              ?.shipping
                                                              ?.shippingCost,
                                                      finalVariation: productDetailsController.finalVariationString,
                                                      sku: productDetailsController.variationsku.value,
                                                      taxJson: taxMap,
                                                      stock: productDetailsController.variationsStock.value,
                                                      shipping: productDetailsController.productModel.value.data?.shipping,
                                                      productVariationPrice: productDetailsController.variationProductPrice.value,
                                                      productVariationOldPrice: productDetailsController.variationProductOldPrice.value,
                                                      productVariationCurrencyPrice: productDetailsController.variationProductCurrencyPrice.value,
                                                      productVariationOldCurrencyPrice: productDetailsController.variationProductOldCurrencyPrice.value,
                                                      totalTax: cartController.totalIndividualProductTax,
                                                      flatShippingCost: authController.settingModel?.data?.shippingSetupFlatRateWiseCost.toString() ?? "0");

                                                  Get.back();
                                                  customSnackbar(
                                                      "SUCCESS".tr,
                                                      "Product added to cart"
                                                          .tr,
                                                      AppColor.success);
                                                } else {}
                                              } else {
                                                //     productDetailsController.variationsStock.value = productDetailsController.productModel.value.data?.stock ?? 0;
                                                if (productDetailsController
                                                        .productModel
                                                        .value
                                                        .data!
                                                        .stock! >
                                                    0) {
                                                  cartController
                                                          .totalIndividualProductTax =
                                                      0.0;

                                                  productDetailsController
                                                      .productModel
                                                      .value
                                                      .data!
                                                      .taxes!
                                                      .map((e) {
                                                    cartController
                                                            .totalIndividualProductTax +=
                                                        double.parse(e.taxRate
                                                            .toString());
                                                  }).toList();

                                                  var taxMap =
                                                      productDetailsController
                                                          .productModel
                                                          .value
                                                          .data!
                                                          .taxes!
                                                          .map((e) {
                                                    return {
                                                      "id": e.id!.toInt(),
                                                      "name": e.name.toString(),
                                                      "code": e.code.toString(),
                                                      "tax_rate":
                                                          double.tryParse(e
                                                              .taxRate
                                                              .toString()),
                                                      'tax_amount':
                                                          double.tryParse(
                                                              cartController
                                                                  .totalTax
                                                                  .toString()),
                                                    };
                                                  }).toList();

                                                  cartController.addItem(
                                                      variationStock: productDetailsController.variationsStock.value
                                                          .toInt(),
                                                      product: productDetailsController
                                                          .productModel.value,
                                                      variationId: productDetailsController.initialVariationModel.value.data == null ||
                                                              productDetailsController
                                                                  .initialVariationModel
                                                                  .value
                                                                  .data!
                                                                  .isEmpty
                                                          ? 0
                                                          : int.parse(productDetailsController
                                                              .variationProductId
                                                              .value),
                                                      shippingAmount: authController.settingModel?.data?.shippingSetupMethod.toString() == "5" && productDetailsController.productModel.value.data?.shipping?.shippingType.toString() == "5"
                                                          ? "0"
                                                          : productDetailsController
                                                              .productModel
                                                              .value
                                                              .data
                                                              ?.shipping
                                                              ?.shippingCost,
                                                      finalVariation: productDetailsController.finalVariationString,
                                                      sku: productDetailsController.productModel.value.data?.sku,
                                                      taxJson: taxMap,
                                                      stock: productDetailsController.productModel.value.data?.stock,
                                                      shipping: productDetailsController.productModel.value.data?.shipping,
                                                      productVariationPrice: productDetailsController.productModel.value.data?.price,
                                                      productVariationOldPrice: productDetailsController.productModel.value.data?.oldPrice,
                                                      productVariationCurrencyPrice: productDetailsController.productModel.value.data?.currencyPrice,
                                                      productVariationOldCurrencyPrice: productDetailsController.productModel.value.data?.oldCurrencyPrice,
                                                      totalTax: cartController.totalIndividualProductTax,
                                                      flatShippingCost: authController.settingModel?.data?.shippingSetupFlatRateWiseCost.toString() ?? "0");

                                                  Get.back();
                                                  customSnackbar(
                                                      "SUCCESS".tr,
                                                      "Product added to cart"
                                                          .tr,
                                                      AppColor.success);
                                                } else {}
                                              }
                                            }),
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          if (box.read('isLogedIn') != false) {
                                            if (productDetailsController
                                                    .productModel
                                                    .value
                                                    .data!
                                                    .wishlist ==
                                                true) {
                                              await wishlistController
                                                  .toggleFavoriteFalse(
                                                      productDetailsController
                                                          .productModel
                                                          .value
                                                          .data!
                                                          .id!);

                                              wishlistController.showFavorite(
                                                  productDetailsController
                                                      .productModel
                                                      .value
                                                      .data!
                                                      .id!);
                                            }
                                            if (productDetailsController
                                                    .productModel
                                                    .value
                                                    .data!
                                                    .wishlist ==
                                                false) {
                                              await wishlistController
                                                  .toggleFavoriteTrue(
                                                      productDetailsController
                                                          .productModel
                                                          .value
                                                          .data!
                                                          .id!);

                                              wishlistController.showFavorite(
                                                  productDetailsController
                                                      .productModel
                                                      .value
                                                      .data!
                                                      .id!);
                                            }
                                          } else {
                                            Get.to(() => const SignInScreen());
                                          }
                                        },
                                        borderRadius:
                                            BorderRadius.circular(24.r),
                                        child: Container(
                                          height: 48.h,
                                          width: 139.w,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(24.r),
                                              color: AppColor.whiteColor,
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.04),
                                                    blurRadius: 8.r,
                                                    offset: const Offset(0, 4))
                                              ]),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SvgPicture.asset(
                                                wishlistController.favList.contains(
                                                            productDetailsController
                                                                .productModel
                                                                .value
                                                                .data!
                                                                .id!) ||
                                                        productDetailsController
                                                                .productModel
                                                                .value
                                                                .data!
                                                                .wishlist ==
                                                            true
                                                    ? SvgIcon.filledHeart
                                                    : SvgIcon.heart,
                                                height: 24.h,
                                                width: 24.w,
                                              ),
                                              SizedBox(width: 8.w),
                                              CustomText(
                                                text: "FAVORITE".tr,
                                                size: 16.sp,
                                                weight: FontWeight.w700,
                                                color: AppColor.textColor,
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 20.h),
                                  const DeviderWidget(),
                                  SizedBox(height: 16.h),
                                  Obx(
                                    () => productDetailsController
                                                .productModel.value.data !=
                                            null
                                        ? productDetailsController.productModel
                                                        .value.data?.details ==
                                                    '' ||
                                                productDetailsController
                                                        .productModel
                                                        .value
                                                        .data
                                                        ?.details ==
                                                    null
                                            ? const SizedBox()
                                            : Html(
                                                data: productDetailsController
                                                    .productModel
                                                    .value
                                                    .data
                                                    ?.details,
                                                style: {
                                                  "p.fancy": Style(
                                                    fontFamily: 'urbanist',
                                                    textAlign: TextAlign.center,
                                                    backgroundColor:
                                                        AppColor.textColor,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                },
                                              )
                                        : const SizedBox(),
                                  ),
                                  SizedBox(height: 16.h),
                                ]),
                    ),
                  ));
            },
          ),
        ),
        Positioned(
          top: 16.h,
          right: 16.w,
          child: InkWell(
            onTap: () {
              Get.back();
            },
            child: SvgPicture.asset(
              SvgIcon.close,
              color: AppColor.redColor,
              height: 24.h,
              width: 24.w,
            ),
          ),
        )
      ],
    );
  }
}
