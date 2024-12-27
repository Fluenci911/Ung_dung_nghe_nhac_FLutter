import 'package:flutter/material.dart';
import 'song_detail_page.dart'; // Import trang chi tiết bài hát
import 'home_page.dart'; // Import trang HomePage

class MusicScr extends StatefulWidget {
  const MusicScr({Key? key}) : super(key: key);

  @override
  _MusicScrState createState() => _MusicScrState();
}

class _MusicScrState extends State<MusicScr> {
  List<Map<String, String>> songs = [
    {'text1': "See You Again", 'text2': "Charlie Puth", 'text3': "sound1.mp3"},
    {'text1': "HathYar", 'text2': "Sidhu Moose Waalaa", 'text3': "sound2.mp3"},
    {'text1': "Trend", 'text2': "Sidhu Moose Waalaa", 'text3': "sound3.mp3"},
    {
      'text1': "Fire Jatt De",
      'text2': "Tarna, Byg Byrd",
      'text3': "sound4.mp3"
    },
    {
      'text1': "El Jatt",
      'text2': "Varinder Brar, Veer Sandhu",
      'text3': "sound5.mp3"
    },
    {'text1': "Poison", 'text2': "Sidhu Moose Waalaa", 'text3': "sound6.mp3"},
    {'text1': "B-Town", 'text2': "Sidhu Moose Waalaa", 'text3': "sound7.mp3"},
    {'text1': "Arrogant", 'text2': "AP Dhillon", 'text3': "sound8.mp3"},
    {'text1': "Faraar", 'text2': "AP Dhillon", 'text3': "sound9.mp3"},
    {'text1': "Shimla", 'text2': "Fateh Shergill ", 'text3': "sound10.mp3"},
    {'text1': "94 Flow", 'text2': "Big Boi Deep", 'text3': "sound11.mp3"},
    {'text1': "Ridxr", 'text2': "Bukka Jatt, R. Nait", 'text3': "sound12.mp3"},
    {
      'text1': "BIR RASS",
      'text2': "Harvi, Veer Sandhu",
      'text3': "sound13.mp3"
    },
    {'text1': "No Stress", 'text2': "Tarna, Byg Byrd", 'text3': "sound14.mp3"},
  ];

  List<Map<String, String>> filteredSongs = [];
  String query = "";
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    filteredSongs = songs; // Initially, all songs are shown
  }

  void updateSearchQuery(String newQuery) {
    setState(() {
      query = newQuery;
      filteredSongs = songs
          .where((song) =>
              song['text1']!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void resetSearch() {
    setState(() {
      query = "";
      filteredSongs = songs; // Reset to original list
    });
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF1D3557),
      elevation: 0,
      title: isSearching
          ? TextField(
              autofocus: true,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Bạn muốn nghe gì?",
                hintStyle: const TextStyle(color: Colors.grey),
                border: InputBorder.none,
              ),
              onChanged: (value) {
                updateSearchQuery(value); // Hàm lọc bài hát
              },
            )
          : const Text(
              "Bài hát yêu thích",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
            ),
      centerTitle: true,
      actions: [
        if (isSearching)
          TextButton(
            onPressed: () {
              setState(() {
                isSearching = false;
                resetSearch(); // Reset danh sách bài hát khi hủy tìm kiếm
              });
            },
            child: const Text(
              "Hủy",
              style: TextStyle(color: Colors.white),
            ),
          )
        else
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              setState(() {
                isSearching = true;
              });
            },
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: buildAppBar(),
      drawer: Drawer(
        child: Container(
          color: const Color(0xFF1D3557),
          child: ListView(
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF4ECDC4), Color(0xFF556270)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Text(
                  'Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.home, color: Colors.white),
                title:
                    const Text('Home', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: filteredSongs.length,
              itemBuilder: (context, index) {
                final song = filteredSongs[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SongDetailPage(
                          text1: song['text1']!,
                          text2: song['text2']!,
                          text3: song['text3']!,
                          lyrics: songs, // Pass song list
                        ),
                      ),
                    );
                  },
                  child: Card(
                    margin: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 16),
                    color: const Color(0xFF1E293B),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 8,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(15),
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundColor: const Color(0xFF9333EA),
                        child: const Icon(
                          Icons.music_note,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      title: Text(
                        song['text1']!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      subtitle: Text(
                        song['text2']!,
                        style: const TextStyle(color: Colors.white70),
                      ),
                      trailing: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF6EE7B7),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        child: const Text(
                          "Nghe",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
