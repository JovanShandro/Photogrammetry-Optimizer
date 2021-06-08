#include <opencv2/core.hpp>
#include <opencv2/imgcodecs.hpp>
#include <opencv2/highgui.hpp>
#include <opencv2/imgproc.hpp>
#include <iostream>
#include <vector>
#include <filesystem>
using namespace cv;
using namespace std;

float coeff = .6;
bool areSimilar(Mat image1, Mat image2);
vector<string> filenames;


int main(int argc, char** argv)
{
    // Read coefficient from arguments
    if (argc > 1) {
        coeff = stof(argv[1]);
        if(coeff >0.9 || coeff < 0.1) {
            cout << "\033[1;31mError! Coefficient must be between 0.1 and 0.9\033[0m\n";
            return 1;
        }
    }

    // Get all image names
    string dir_path = "files/";

    for(const auto & file : filesystem::directory_iterator(dir_path))
        filenames.push_back(file.path());

    sort(filenames.begin(), filenames.end());

    // Create mve/images folder if not there
    const string current_path = (string)filesystem::current_path();
    if(!filesystem::is_directory(current_path + "/mve")) {
        filesystem::create_directory(current_path + "/mve");
        if(!filesystem::is_directory(current_path + "/mve/images")) {
            filesystem::create_directory(current_path + "/mve/images");
        }
    }

    // Start comparison
    cout << "\033[1;36mStarting comparsion with coefficient " << coeff << "\033[0m\n";
    Mat prev = imread(filenames[0], IMREAD_COLOR);
    int prev_index = 0;

    int count = 1;
    imwrite("mve/images/"+ to_string(count++) + ".png", prev);

    for(int current_index = 1; current_index<filenames.size(); current_index++) {
        Mat current = imread(filenames[current_index], IMREAD_COLOR);
        cout << "Comparing " << filenames[prev_index] << " with " << filenames[current_index] << endl;

        if(!areSimilar(prev, current)) {
            cout << "\033[1;34mImages are not similar: " << filenames[current_index] << " will now be used for comparisons.\033[0m" << endl;
            prev = current;
            prev_index = current_index;
            imwrite("mve/images/"+ to_string(count++) + ".png", current);
        } else {
            cout << "\033[1;35mImages are similar: " << filenames[current_index] << " was discarded.\033[0m" << endl;
        }
    }

    return 0;
}

bool areSimilar(Mat image1, Mat image2) {
    Mat scoreImg;
    double maxScore;

    cv::matchTemplate(image1, image2, scoreImg, cv::TM_CCOEFF_NORMED);
    minMaxLoc(scoreImg, 0, &maxScore);
    return maxScore >= coeff;
}
