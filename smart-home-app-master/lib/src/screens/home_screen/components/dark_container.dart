// import 'package:domus/config/size_config.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
//
// class DarkContainer extends StatelessWidget {
//   final String iconAsset;
//   final VoidCallback onTap;
//   final String device;
//   final String deviceCount;
//   final bool itsOn;
//   final VoidCallback switchButton;
//   final bool isFav;
//   final VoidCallback switchFav;
//   const DarkContainer({
//     Key? key,
//     required this.iconAsset,
//     required this.onTap,
//     required this.device,
//     required this.deviceCount,
//     required this.itsOn,
//     required this.switchButton,
//     required this.isFav,
//     required this.switchFav,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       child: Container(
//         width: getProportionateScreenWidth(140),
//         height: getProportionateScreenHeight(140),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(20),
//           color: itsOn
//               ? const Color(0xffededed)
//               : const Color.fromRGBO(0, 0, 0, 1),
//         ),
//         child: Padding(
//           padding: EdgeInsets.symmetric(
//             horizontal: getProportionateScreenWidth(10),
//             vertical: getProportionateScreenHeight(6),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Container(
//                     width: 50,
//                     height: 50,
//                     decoration: BoxDecoration(
//                       color: itsOn
//                           ? const Color(0xffdadada)
//                           : const Color.fromRGBO(45, 45, 45, 1),
//                       borderRadius:
//                           const BorderRadius.all(Radius.elliptical(45, 45)),
//                     ),
//                     child: SvgPicture.asset(
//                       iconAsset,
//                       color: itsOn ?  const Color(0xFF808080): Colors.amber,
//                     ),
//                   ),
//                   GestureDetector(
//                     onTap: switchFav,
//                     child:  Icon(
//                       Icons.star_rounded,
//                       color: isFav ?  const Color(0xFF808080):Colors.amber,
//                       // color: Color(0xFF808080),
//                     ),
//                   ),
//                 ],
//               ),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     device,
//                     textAlign: TextAlign.left,
//                     style: Theme.of(context).textTheme.displayMedium!.copyWith(
//                           color: itsOn ?  Colors.black: Colors.white,
//                         ),
//                   ),
//                   Text(
//                     deviceCount,
//                     textAlign: TextAlign.left,
//                     style: const TextStyle(
//                         color: Color.fromRGBO(166, 166, 166, 1),
//                         fontSize: 13,
//                         letterSpacing: 0,
//                         fontWeight: FontWeight.normal,
//                         height: 1.6),
//                   ),
//                 ],
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     itsOn ? 'On' : 'Off',
//                     textAlign: TextAlign.left,
//                     style: Theme.of(context).textTheme.displayMedium!.copyWith(
//                           color: itsOn ?  Colors.black: Colors.white,
//                         ),
//                   ),
//                   GestureDetector(
//                     onTap: switchButton,
//                     child: Container(
//                       width: 48,
//                       height: 25.6,
//                       padding: const EdgeInsets.all(2),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(20),
//                         color: itsOn ?  const Color(0xffd6d6d6): Colors.black,
//                         border: Border.all(
//                           color: const Color.fromRGBO(255, 255, 255, 1),
//                           width: itsOn ? 2 : 0,
//                         ),
//                       ),
//                       child: Row(
//                         children: [
//                           itsOn ? const Spacer() : const SizedBox(),
//                           Container(
//                             width: 20,
//                             height: 20,
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(50),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//


import 'package:domus/config/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DarkContainer extends StatelessWidget {
  final String iconAsset;
  final VoidCallback onTap;
  final String device;
  final String currentReading; // Updated parameter name
  final bool itsOn;
  final VoidCallback switchButton;
  final bool isFav;
  final VoidCallback switchFav;

  const DarkContainer({
    Key? key,
    required this.iconAsset,
    required this.onTap,
    required this.device,
    required this.currentReading, // Updated parameter name
    required this.itsOn,
    required this.switchButton,
    required this.isFav,
    required this.switchFav,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: getProportionateScreenWidth(140),
        height: getProportionateScreenHeight(140),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: itsOn
              ? const Color(0xffededed)
              : const Color.fromRGBO(0, 0, 0, 1),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(10),
            vertical: getProportionateScreenHeight(6),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: itsOn
                          ? const Color(0xffdadada)
                          : const Color.fromRGBO(45, 45, 45, 1),
                      borderRadius:
                      const BorderRadius.all(Radius.elliptical(45, 45)),
                    ),
                    child: SvgPicture.asset(
                      iconAsset,
                      color: itsOn ? const Color(0xFF808080) : Colors.amber,
                    ),
                  ),
                  GestureDetector(
                    onTap: switchFav,
                    child: Icon(
                      Icons.star_rounded,
                      color: isFav ? const Color(0xFF808080) : Colors.amber,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    device,
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                      color: itsOn ? Colors.black : Colors.white,
                    ),
                  ),
                  Text(
                    currentReading, // Updated to show current reading
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                        color: Color.fromRGBO(166, 166, 166, 1),
                        fontSize: 13,
                        letterSpacing: 0,
                        fontWeight: FontWeight.normal,
                        height: 1.6),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    itsOn ? 'On' : 'Off',
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                      color: itsOn ? Colors.black : Colors.white,
                    ),
                  ),
                  GestureDetector(
                    onTap: switchButton,
                    child: Container(
                      width: 48,
                      height: 25.6,
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: itsOn ? const Color(0xffd6d6d6) : Colors.black,
                        border: Border.all(
                          color: const Color.fromRGBO(255, 255, 255, 1),
                          width: itsOn ? 2 : 0,
                        ),
                      ),
                      child: Row(
                        children: [
                          itsOn ? const Spacer() : const SizedBox(),
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
