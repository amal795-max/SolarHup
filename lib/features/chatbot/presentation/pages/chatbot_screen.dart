import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/theme/app_style.dart';
import 'package:untitled1/widgets/custom_text_field.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/helper/extensions.dart';

class Message {
  final String text;
  final bool isUser;
  final bool isProduct;
  final Map<String, dynamic>? productData;

  Message({
    required this.text,
    required this.isUser,
    this.isProduct = false,
    this.productData,
  });
}

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final List<Message> _messages = [
    Message(
      text:
      'Hello! I can help you find the perfect solar solution. How can I assist you today?',
      isUser: false,
    ),
  ];

  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;

    setState(() {
      _messages.add(Message(text: _controller.text, isUser: true));
      _controller.clear();
    });

    _scrollToBottom();

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _messages.add(
            Message(
              text:
              'Based on your request, I recommend looking at our 5kW system which would offset most of your costs.',
              isUser: false,
            ),
          );
          _messages.add(
            Message(
              text: 'SolarCore 5kW Kit',
              isUser: false,
              isProduct: true,
              productData: {
                'name': 'SolarCore 5kW Kit',
                'desc': 'Premium monocrystalline panels with smart inverter.',
                'price': '\$6,499',
              },
            ),
          );
        });
        _scrollToBottom();
      }
    });
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('chatbot_title'.tr())),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.all(16.w),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                if (msg.isProduct) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 16.h),
                    child: _buildProductCard(context, msg.productData!),
                  );
                }
                return Padding(
                  padding: EdgeInsets.only(bottom: 16.h),
                  child: msg.isUser
                      ? _buildUserMessage(context, msg.text)
                      : _buildBotMessage(context, msg.text),
                );
              },
            ),
          ),
          _buildBottomInput(context),
        ],
      ),
    );
  }

  Widget _buildBotMessage(BuildContext context, String text) {
    return Row(
      spacing: 8.w,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 18.r,
          backgroundColor: AppColors.primaryColor,
          child: Icon(Icons.bolt, color: Colors.white, size: 20.sp),
        ),
        Flexible(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: context.colorScheme.surface,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(16.r),
                bottomLeft: Radius.circular(16.r),
                bottomRight: Radius.circular(16.r),
              ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Text(text, style: AppStyle.bodyMedium),
          ),
        ),
      ],
    );
  }

  Widget _buildUserMessage(BuildContext context, String text) {
    return Row(
      spacing: 8.w,
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                bottomLeft: Radius.circular(16.r),
                bottomRight: Radius.circular(16.r),
              ),
            ),
            child: Text(
              text,
              style: AppStyle.bodyMedium.copyWith(
                color: Colors.white,
              ),
            ),
          ),
        ),
        CircleAvatar(
          radius: 18.r,
          backgroundColor: context.colorScheme.tertiaryContainer,
          child: Icon(
            Icons.person,
            color: context.colorScheme.onSurface,
            size: 20.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildProductCard(BuildContext context, Map<String, dynamic> data) {
    return Container(
      margin: EdgeInsets.only(left: 44.w),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 120.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: context.brightness
                  ? AppColors.darkGray
                  : AppColors.lightGrey.withOpacity(0.5),
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
            ),
            child: Icon(Icons.solar_power, size: 60.sp, color: Colors.grey),
          ),
          Padding(
            padding: EdgeInsets.all(12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data['name'],
                  style: AppStyle.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(data['desc'], style: AppStyle.bodySmall),
                SizedBox(height: 12.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      data['price'],
                      style: context.textTheme.titleMedium?.copyWith(
                        color: context.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        minimumSize: Size(100.w, 36.h),
                      ),
                      child: Text(
                        'view_system'.tr(),
                        style: TextStyle(fontSize: 12.sp),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomInput(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildQuickAction('analyze_my_bill'.tr()),
                  SizedBox(width: 8.w),
                  _buildQuickAction('suggest_off_grid'.tr()),
                ],
              ),
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Icon(
                  Icons.attach_file,
                  color: context.colorScheme.onSurface.withOpacity(0.6),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: CustomTextField(
                    controller: _controller,
                    hasTitle: false,
                    hint: 'ask_about_solar'.tr(),
                    onFieldSubmitted: (_) => _sendMessage(),
                    title: '',
                  ),
                ),
                SizedBox(width: 12.w),
                GestureDetector(
                  onTap: _sendMessage,
                  child: Container(
                    padding: EdgeInsets.all(10.r),
                    decoration: const BoxDecoration(
                      color: AppColors.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.send, color: Colors.white, size: 20.sp),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAction(String label) {
    return GestureDetector(
      onTap: () {
        _controller.text = label;
        _sendMessage();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: context.brightness
              ? AppColors.darkGray
              : AppColors.lightGrey.withOpacity(0.5),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Text(
          label,
          style: context.textTheme.bodySmall?.copyWith(
            color: context.colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}
