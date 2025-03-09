// ignore_for_file: must_be_immutable, deprecated_member_use

import 'package:ebazaar/utils/svg_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../../config/theme/app_color.dart';
import '../../../../../utils/constant.dart';
import '../../controller/address_controller.dart';

class AddBottomSheetAddress extends StatefulWidget {
  const AddBottomSheetAddress({super.key});

  @override
  State<AddBottomSheetAddress> createState() => _ItemCautionState();
}

class _ItemCautionState extends State<AddBottomSheetAddress> {
  final addressController = Get.put(AddressController());
  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    addressController.addressTypeIndex = -1;
    addressController.apartmentController.text = "";
    addressController.labelController.text = "";
    addressController.selectedAddressType = "";

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddressController>(
      builder:
          (addressController) => Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: AppColor.grayColor.withOpacity(0.5),
                  offset: const Offset(0.0, 6.0),
                  blurRadius: 30.r,
                  spreadRadius: 10.r,
                ),
                //BoxShadow
                //BoxShadow
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 24.h,
                          width: 24.w,
                          child: SvgPicture.asset(
                            SvgIcon.menuLocation,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 10.w),
                        InkWell(
                          child: SizedBox(
                            height: 50.h,
                            width: 290.w,
                            child: Text(
                              addressController.pickAddress == ''
                                  ? addressController.currentPositionName
                                      .toString()
                                  : addressController.pickAddress.toString(),
                              style: TextStyle(
                                fontFamily: 'Rubik',
                                fontWeight: FontWeight.w400,
                                fontSize: 14.sp,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("APPARTMENT_&_FLAT_NO".tr, style: fontRegular),
                      SizedBox(height: 4.h),
                      SizedBox(
                        child: TextField(
                          showCursor: true,
                          readOnly: false,
                          controller: addressController.apartmentController,
                          expands: false,
                          decoration: InputDecoration(
                            fillColor: AppColor.borderColor,
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(12.0.r),
                              ),
                              borderSide: BorderSide(
                                color: AppColor.borderColor,
                                width: 2.0.w,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(12.0.r),
                              ),
                              borderSide: BorderSide(
                                width: 2.w,
                                color: AppColor.borderColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("ADD_LABEL".tr, style: fontMedium),
                      SizedBox(height: 9.h),
                      SizedBox(
                        height: 50.h,
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: addressController.addressTypeList.length,
                          itemBuilder: (BuildContext context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: InkWell(
                                onTap: () {
                                  addressController.setAddressTypeIndex(index);
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      height: 48.h,
                                      width: 88.w,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          8.r,
                                        ),
                                        color:
                                            addressController
                                                        .addressTypeIndex ==
                                                    index
                                                ? AppColor.primaryColor
                                                    .withOpacity(0.08)
                                                : AppColor.borderColor,
                                        border:
                                            addressController
                                                        .addressTypeIndex ==
                                                    index
                                                ? Border.all(
                                                  color: AppColor.primaryColor,
                                                )
                                                : Border.all(
                                                  color: Colors.white,
                                                ),
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          addressController
                                                      .addressTypeList[index]
                                                      .toString() ==
                                                  "Home"
                                              ? SvgPicture.asset(
                                                SvgIcon.home,
                                                fit: BoxFit.cover,
                                                height: 15.h,
                                                width: 15.w,
                                                color:
                                                    addressController
                                                                .addressTypeIndex ==
                                                            index
                                                        ? const Color(
                                                          0xff006CC0,
                                                        )
                                                        : AppColor.iconColor,
                                              )
                                              : addressController
                                                      .addressTypeList[index]
                                                      .toString() ==
                                                  "Office"
                                              ? SvgPicture.asset(
                                                SvgIcon.work,
                                                fit: BoxFit.cover,
                                                color:
                                                    addressController
                                                                .addressTypeIndex ==
                                                            index
                                                        ? null
                                                        : AppColor.iconColor,
                                              )
                                              : SvgPicture.asset(
                                                SvgIcon.other,
                                                fit: BoxFit.cover,
                                                color:
                                                    addressController
                                                                .addressTypeIndex ==
                                                            index
                                                        ? null
                                                        : AppColor.iconColor,
                                              ),
                                          SizedBox(width: 8.w),
                                          Text(
                                            addressController
                                                .addressTypeList[index],
                                            style: fontMediumPro,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      if (addressController.selectedAddressType != "Home" &&
                          addressController.selectedAddressType != "Office" &&
                          addressController.addressTypeIndex == 2)
                        Form(
                          key: formKey,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: SizedBox(
                              child: TextFormField(
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Please add level";
                                  } else {
                                    return null;
                                  }
                                },
                                controller: addressController.labelController,
                                expands: false,
                                decoration: InputDecoration(
                                  fillColor: AppColor.borderColor,
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(12.0.r),
                                    ),
                                    borderSide: BorderSide(
                                      color: AppColor.borderColor,
                                      width: 2.0.w,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(12.0.r),
                                    ),
                                    borderSide: BorderSide(
                                      width: 2.w,
                                      color: AppColor.borderColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 24.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            await addressController.addAddress();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.primaryColor,
                            minimumSize: Size(328.w, 52.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24.r),
                            ),
                          ),
                          child: Text("CONFIRM_LOCATION".tr, style: fontMedium),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }
}
