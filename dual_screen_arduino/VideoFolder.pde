class VideoFolder {
  private String folder;
  private ArrayList<String> files;
  private int current = -1;
  public VideoFolder(File f) {
    this.folder = f.getName();
    this.files = new ArrayList<String>();
    File[] listOfFiles = f.listFiles();
    for (File file : listOfFiles) {
        if (file.isFile()) {
          String n = file.getName();
          if (n.substring(n.length()-4,n.length()).equals(".mp4")) {
            this.files.add(n);
          }
        }
    }
  }
  public String keyword() {
    return folder.toLowerCase();
  }
  public int size() {
    return files.size();
  }
  public String get_video() {
    current++;
    if (current == files.size()) {
      current = 0;
    }
    return folder+"/"+files.get(current);
  }
}