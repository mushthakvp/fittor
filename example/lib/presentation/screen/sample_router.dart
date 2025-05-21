import 'package:cached_network_image/cached_network_image.dart';
import 'package:fittor/fittor.dart';
import 'package:flutter/material.dart';

class SampleRouter extends StatefulWidget {
  const SampleRouter({super.key});

  @override
  State<SampleRouter> createState() => _SampleRouterState();
}

class _SampleRouterState extends State<SampleRouter> {
  String? args;

  @override
  void initState() {
    super.initState();
    args = FitRoute.arguments as String?;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigoAccent,
        title: Text('Sample Router', style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CachedNetworkImage(
            imageUrl:
                'https://images.unsplash.com/photo-1506744038136-46273834b3fb',
            placeholder: (context, url) {
              return FittorBlurAsh(
                hash: 'UbCP*BWYWWof~qWraykC_3WYjZof?bflaxoL',
                width: 300,
                height: 200,
              );
            },
            errorWidget: (context, url, error) {
              return FittorBlurAsh(
                hash: 'UbCP*BWYWWof~qWraykC_3WYjZof?bflaxoL',
                width: 300,
                height: 200,
              );
            },
            width: 300,
            height: 200,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 20),
          Center(
            child: Text(
              'Sample Router',
              style: TextStyle(fontSize: context.fs30),
            ),
          ),
          Text('Args: $args', style: TextStyle(fontSize: context.fs30)),
        ],
      ),
    );
  }
}
