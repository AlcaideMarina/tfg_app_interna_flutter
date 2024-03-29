import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hueveria_nieto_interna/data/models/fpc_model.dart';

import '../data/models/local/monthly_fpc_container_data.dart';
import '../data/models/local/weekly_monitoring_company_situation_data.dart';
import '../data/models/monitoring_company_situation_model.dart';
import 'Utils.dart';

class FarmUtils {
  List<FPCModel> getFPCModel(List? mapList) {
    List<FPCModel> list = [];

    if (mapList != null) {
      for (var item in mapList) {
        FPCModel fpcModel = FPCModel.fromMap(item.data(), item.id);
        list.add(FPCModel(
            fpcModel.acceptedEggs,
            fpcModel.bestBeforeDatetime,
            fpcModel.createdBy,
            fpcModel.creationDatetime,
            fpcModel.deleted,
            fpcModel.issueDatetime,
            fpcModel.layingDatetime,
            fpcModel.lot,
            fpcModel.packingDatetime,
            fpcModel.rejectedEggs,
            fpcModel.documentId));
      }
    }
    return list;
  }

  List<MonthlyFPCContainerData> getMonthlyFPCModelFromFPCModelList(
      List<FPCModel> fpcModelList) {
    List<MonthlyFPCContainerData> list = [];

    fpcModelList.sort((a, b) => b.layingDatetime.compareTo(a.layingDatetime));

    if (fpcModelList.isNotEmpty) {
      FPCModel firstFPC = fpcModelList[0];
      DateTime firstDate = firstFPC.layingDatetime.toDate();

      String m = firstDate.month.toString();
      while (m.length < 2) {
        m = '0' + m;
      }
      String y = firstDate.year.toString();
      while (y.length < 4) {
        y = '0' + y;
      }

      // Creamos fecha inicial y final
      Timestamp initDateTimestamp = Utils().parseStringToTimestamp('01/$m/$y');
      Timestamp endDateTimestamp = Timestamp.fromDate(
          Utils().addToDate(initDateTimestamp.toDate(), monthsToAdd: 1));

      List<FPCModel> monthlyFPCDataList = [];
      for (FPCModel item in fpcModelList) {
        if (initDateTimestamp.compareTo(item.layingDatetime) > 0) {
          MonthlyFPCContainerData monthlyFPCContainerData =
              MonthlyFPCContainerData(
                  initDateTimestamp, endDateTimestamp, monthlyFPCDataList);
          list.add(monthlyFPCContainerData);

          String m = item.layingDatetime.toDate().month.toString();
          while (m.length < 2) {
            m = '0' + m;
          }
          String y = item.layingDatetime.toDate().year.toString();
          while (y.length < 4) {
            y = '0' + y;
          }

          // Creamos fecha inicial y final
          initDateTimestamp = Utils().parseStringToTimestamp('01/$m/$y');
          endDateTimestamp = Timestamp.fromDate(
              Utils().addToDate(initDateTimestamp.toDate(), monthsToAdd: 1));
          monthlyFPCDataList = [];
        }
        monthlyFPCDataList.add(item);

        if (fpcModelList.last == item) {
          MonthlyFPCContainerData monthlyFPCContainerData =
              MonthlyFPCContainerData(
                  initDateTimestamp, endDateTimestamp, monthlyFPCDataList);
          list.add(monthlyFPCContainerData);

          endDateTimestamp = initDateTimestamp;
          initDateTimestamp = Timestamp.fromDate(
              Utils().addToDate(initDateTimestamp.toDate(), monthsToAdd: -1));
        }
      }
    }
    return list;
  }

  WeeklyMonitoringCompanySituationData parseFromFarmSituationToModel(
      QuerySnapshot<Object?> data) {
    int hensLosses = 0;
    int weeklyLaying = 0;
    int xlEggs = 0;
    int lEggs = 0;
    int mEggs = 0;
    int sEggs = 0;

    if (data.docs.isNotEmpty) {
      for (var r in data.docs) {
        if (r.data() != null) {
          MonitoringCompanySituationModel mcsModel =
              MonitoringCompanySituationModel.fromMap(
                  r.data() as Map<String, dynamic>, r.id);
          hensLosses += mcsModel.hens["losses"] as int;
          xlEggs += mcsModel.xlEggs["eggs"] as int;
          lEggs += mcsModel.lEggs["eggs"] as int;
          mEggs += mcsModel.mEggs["eggs"] as int;
          sEggs += mcsModel.sEggs["eggs"] as int;

          weeklyLaying += (mcsModel.xlEggs["eggs"] as int) +
              (mcsModel.lEggs["eggs"] as int) +
              (mcsModel.mEggs["eggs"] as int) +
              (mcsModel.sEggs["eggs"] as int);
        }
      }
    }

    return WeeklyMonitoringCompanySituationData(
        hensLosses, weeklyLaying, xlEggs, lEggs, mEggs, sEggs);
  }
}
