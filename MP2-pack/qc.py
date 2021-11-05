import sys

TEST  = 1
TRAIN = 2
# 6 argumentos 

"""def wrong_args():
    print("Wrong arguments")
    exit()

if len(sys.argv) != 6:
    wrong_args()"""


    
def split (file, vector_labels, vector_questions_answer):
    for line in file:
        vector_labels = vector_labels + [line.split()[0]]
        vector_questions_answer= vector_questions_answer + [line.split()[1:]] 
    return vector_labels,vector_questions_answer


def Jaccard_Similarity(line1, line2): 
    words_line1 = set(line1.lower().split()) 
    words_line2 = set(line2.lower().split())
    
    # Find the intersection of words list of doc1 & doc2
    intersection = words_line1.intersection(words_line2)

    # Find the union of words list of doc1 & doc2
    union = words_line1.union(words_line2)
        
    # Calculate Jaccard similarity score 
    # using length of intersection set divided by length of union set
    return float(len(intersection)) / len(union)

#Para cada linha do dev vamos encontrar a linha do train com maior jacard
#vemos qual a label do train correspondente e colocamos essa label no nosso vetor de respostas. 
#No fim comparamos o vetor de respostas com o nosso vetor e vemos quantas acertamos e quantas falhamos para calcular uma percentagem
def main():
    print("ola")
    train_file = open(sys.argv[1], "r")
    dev_file = open(sys.argv[2], "r")

    train_labels=[]
    train_questions_answer= []
    dev_right_labels = [] #respostas certas
    dev_questions_answer = []
    dev_model_labels = [] #respostas que o nosso modelo da

    train_labels,train_questions_answer = split(train_file,train_labels,train_questions_answer)
    dev_right_labels, dev_questions_answer = split(dev_file,dev_right_labels,dev_questions_answer)
    aux= 0
    Line_aux = 0
    i=0
    j=0
    print(dev_questions_answer)
    print(train_labels)

    """for lineDev in dev_questions_answer:
        print("ola2")
        for lineTrain in train_questions_answer:
            result = Jaccard_Similarity(lineDev,lineTrain)
            if(result > aux):
                aux = result
                Line_aux = i
            i = i + 1 
        dev_model_labels[j] = train_labels[i] 
        j = j + 1
        print(result)"""
        
        
#definir label 
#depois comparar o dev_model_labels com right_labels 
#ver que nr da de de certas fazer dps um for ate este numero mudar se n nao mudar  parar
    
    
    
 
    
if __name__ == "__main__":
    main()
    
#print(train_questions_answer)



  















    


