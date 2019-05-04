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

// se llama cuando el usuario elije la carpeta
void folderSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + selection.getAbsolutePath());
    vf = new VideoFolder(selection);
    //println(vf.size());
    //println(vf.files);
    videosList.clear();    
    videosList.addItems(vf.files);
    videosList.open();
    dbConnect(vf);
    dbAddFiles(vf);
  }
}
