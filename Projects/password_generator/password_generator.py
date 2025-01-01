import random,string

def generate_password(min_length, numbers = True, special_characters = True):
    letters = string.ascii_letters
    digits = string.digits
    special = string.punctuation
    
    characters = letters
    if numbers:
        characters += digits
    if special_characters:
        characters += special
        
    password = ''
    meets_criteria = False
    has_number = False
    has_special = False
    
    while not meets_criteria or len(password) <  min_length:
        new_char = random.choice(characters)
        password += new_char
        
        if new_char in digits :
            has_number = True
        elif new_char in special:
            has_special = True
            
        meets_criteria = True
        if numbers:
            meets_criteria = numbers
        if special_characters:
            meets_criteria = has_special and meets_criteria
            
    return password

min_length = int(input("Enter the minimum length of the password :"))
has_number = input("Do you want to have a number in your password? (y/n) :" ).lower() == 'y'
has_special = input("Do you want to have special characters in your password? (y/n) :" ).lower() == 'y'
password = generate_password(min_length, has_number, has_special)
print(f'The generated password is : {password}')