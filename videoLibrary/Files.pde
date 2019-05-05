VideoFolder vf;

class VideoFolder {

  private ArrayList<String> files;
  private File folder;
  public VideoFolder(File f) {
    this.folder = f;
    this.files = new ArrayList<String>();
    File[] listOfFiles = f.listFiles();
    for (File file : listOfFiles) {
      if (file.isFile()) {
        String n = file.getName();
        if (n.substring(n.length()-4, n.length()).equals(".mp4")) {
          this.files.add(n);
        }
      }
    }
  }

  public int size() {
    return files.size();
  }

  public String get_video(int file) {
    return this.folder.getPath() + File.separator + files.get(file);
  }
}
