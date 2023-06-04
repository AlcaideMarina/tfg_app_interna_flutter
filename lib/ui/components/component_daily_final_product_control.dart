import 'package:flutter/material.dart';
import 'package:hueveria_nieto_interna/data/models/fpc_model.dart';

import '../../custom/custom_colors.dart';
import '../../utils/Utils.dart';
import '../../values/image_routes.dart';

class HNComponentDailyFPC extends StatelessWidget {

  final FPCModel fpcModel;
  final Function()? onTap;

  const HNComponentDailyFPC(this.fpcModel, {Key? key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(Utils().parseTimestmpToString(fpcModel.issueDatetime, dateFormat: "dd/MM") ?? ""),
          SizedBox(
            width: 16,
          ),
          Flexible(
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      ImageRoutes.getRoute('ic_right_tic'), 
                      width: 16,
                      height: 24,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(fpcModel.acceptedEggs.toString() + " aceptados"),
                  ],
                ),
                SizedBox(
                  height: 4,
                ),
                Container(
                  height: 1,
                  color: CustomColors.redPrimaryColor,
                ),
                SizedBox(
                  height: 4,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      ImageRoutes.getRoute('ic_wrong'), 
                      width: 16,
                      height: 24,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(fpcModel.acceptedEggs.toString() + " rechazados"),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            width: 16,
          ),
          onTap != null ? Image.asset(
            ImageRoutes.getRoute('ic_next_arrow'), 
            width: 16,
            height: 24,)
          : Container()
        ],
      ),
      decoration: BoxDecoration(
        color: CustomColors.redGraySecondaryColor,
        border: Border.all(
          color: CustomColors.redGraySecondaryColor,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(20))
      ),
    ));
  }
}
