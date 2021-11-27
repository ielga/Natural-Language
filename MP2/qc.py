from __future__ import division
from sklearn.feature_extraction.text import TfidfVectorizer
import sys
from sklearn.preprocessing import LabelEncoder
from sklearn import svm

## Taxa de acerto com dev_file:  87 por cento


def wrong_usage():
    sys.stderr.print("Wrong usage, the correct usage is: python qc.py –test NAMEOFTESTFILE –train NAMEOFTHETRAINFILE")
    exit()

def split (file, vector_labels, vector_questions_answer):
    for line in file:
        vector_labels = vector_labels + [line.split()[0]]
        vector_questions_answer= vector_questions_answer + [line.split()[1:]] 

    return vector_labels,vector_questions_answer

def listToString(s): 
    str1 = "" 
    for ele in s: 
        str1 += ele + ' '
    return str1 

def StringToList(dev_questions_answer,train_questions_answer):
    dev_questions=[]
    train_questions=[]
    for dev_line in dev_questions_answer:
        sentence1 = listToString(dev_line)
        dev_questions += [sentence1]
    for line_train in train_questions_answer:
        sentence2 = listToString(line_train)
        train_questions += [sentence2]
    return dev_questions,train_questions

def tfidf_with_SVM(train_labels,dev_questions,train_questions):
    Encoder = LabelEncoder()
    train_labels = Encoder.fit_transform(train_labels)

    Tfidf_vect = TfidfVectorizer()
    Tfidf_vect.fit(dev_questions + train_questions)
    train_questions_tfidf = Tfidf_vect.transform(train_questions)
    dev_questions_tfidf = Tfidf_vect.transform(dev_questions)

    SVM = svm.SVC(C=1.0, kernel='linear', degree=3, gamma='auto')
    SVM.fit(train_questions_tfidf, train_labels)
    dev_model_labels = SVM.predict(dev_questions_tfidf)
    labels = Encoder.inverse_transform(dev_model_labels)
    return labels


def main():
    #verify arguments
    if len(sys.argv) != 5:
        wrong_usage()
    
    if ((sys.argv[1] != "-test") or (sys.argv[3] != "-train")) :
        wrong_usage()


    train_labels=[]
    train_questions_answer= []
    dev_questions_answer = []
    dev_labels = []
   

    train_file = open(sys.argv[4], "r") 
    dev_file = open(sys.argv[2], "r")

    #split train labels and questions
    train_labels,train_questions_answer = split(train_file,train_labels,train_questions_answer)
   

    #development/test pre processing
    for line in dev_file:
        dev_questions_answer += [line.split()]

   
    train_file.close()
    dev_file.close()
    
    dev_questions,train_questions = StringToList(dev_questions_answer,train_questions_answer)
    #calculate prediction
    dev_labels = tfidf_with_SVM(train_labels,dev_questions,train_questions)


    for prediction in dev_labels:
         print(prediction)
    
       
if __name__ == "__main__":
    main()



  















    


