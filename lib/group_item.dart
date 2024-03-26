class GroupItem {
  late String name; // 그룹 이름
  late String description; // 그룹 설명
  late String tags; // 그룹 태그
  late List<String> selectedMembers; // 선택된 멤버 목록

  GroupItem({
    required this.name,
    required this.description,
    required this.tags,
    required this.selectedMembers,
  });
}
