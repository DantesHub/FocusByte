
import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn
import FirebaseAuth
import Validator
var userEmail = ""
class RegisterViewController: UIViewController, GIDSignInDelegate {
    
    //MARK: - properties
    var registerTitle = UILabel()
    var password = UITextField()
    var email = UITextField()
    var passwordConfirmation = UITextField()
    var signUpView = UIView()
    var signUpLabel = UILabel()
    var registerErrorLabel = UILabel(frame: CGRect(x: 100, y: 620, width: buttonWidth, height: 45))
    var emailIsValid = false
    var passwordIsValid = false
    var passwordConfirmationIsValid = false
    var googleImage: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "googleButton")
        iv.isUserInteractionEnabled = true
        iv.contentMode = .scaleAspectFit
        iv.layer.cornerRadius = 25
        return iv
    }()
    var ValInput = ValidateInputs()
    let container: UIView = UIView()
    var spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    
    //MARK: - init
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        view.insertSubview(background, at: 0)
        NSLayoutConstraint.activate([
            background.topAnchor.constraint(equalTo: view.topAnchor),
            background.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            background.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            background.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        super.viewWillAppear(animated)
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().delegate = self
        
    }
    
    //MARK: - Handlers
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        if let error = error {
            print(error)
            return
        }
        Auth.auth().fetchSignInMethods(forEmail: user.profile.email, completion: {
            (providers, error) in
            if let error = error {
                print(error.localizedDescription)
                print("gung")
            } else if let providers = providers {
                if providers.count != 0 {
                    print("pros")
                    self.registerErrorLabel.text = "Please use the login page"
                    self.registerErrorLabel.textColor = .red
                    self.registerErrorLabel.center.y = self.view.center.y + 220
                    self.view.addSubview(self.registerErrorLabel)
                    return
                }
            }
            guard let authentication = user.authentication else { return }
            
            let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                           accessToken: authentication.accessToken)
            
            
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if let error = error {
                    self.registerErrorLabel.text = "Something went wrong"
                    self.registerErrorLabel.textColor = .red
                    self.registerErrorLabel.center.y = self.view.center.y + 220
                    self.view.addSubview(self.registerErrorLabel)
                    print(error)
                } else {
                    self.registerErrorLabel.removeFromSuperview()
                    print("user is signed in")
                    userEmail = String(signIn.currentUser.userID)
                    let genderVC = GenderViewController()
                    genderVC.modalPresentationStyle = .fullScreen
                    self.navigationController?.pushViewController(genderVC, animated: true)
                }
            }
            
        })
        
    }
    
    @objc func tappedRegister() {
        showSpinner()
        if let constant = email.text {
            ValInput.email = constant
            emailIsValid = ValInput.isEmailValid()
            if emailIsValid {
                let color = UIColor.placeholderGray
                let placeholder = "Email" //There should be a placeholder set in storyboard or elsewhere string or pass empty
                email.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor : color])
            } else {
                email.text = ""
                let color = UIColor.red
                let placeholder = "Invalid Email" //There should be a placeholder set in storyboard or elsewhere string or pass empty
                email.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor : color])
                self.spinner.stopAnimating()
                container.removeFromSuperview()
            }
        }
        if let constant = password.text {
            ValInput.password = constant
            passwordIsValid = ValInput.isPasswordLengthValid()
            let passwordIsNumeric = ValInput.doesPasswordHaveDigits()
            if passwordIsValid && passwordIsNumeric{
                let color = UIColor.placeholderGray
                let placeholder = "Password" //There should be a placeholder set in storyboard or elsewhere string or pass empty
                password.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor : color])
            } else if !passwordIsValid {
                password.text = ""
                let color = UIColor.red
                let placeholder = "At least 5 characters" //There should be a placeholder set in storyboard or elsewhere string or pass empty
                password.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor : color])
                self.spinner.stopAnimating()
                container.removeFromSuperview()
            } else if !passwordIsNumeric {
                password.text = ""
                let color = UIColor.red
                let placeholder = "Must contain numbers"
                password.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor : color])
                self.spinner.stopAnimating()
                container.removeFromSuperview()
            }
            
        }
        
        if let constant = passwordConfirmation.text {
            ValInput.passwordConfirmation = constant
            passwordConfirmationIsValid = ValInput.isPasswordConfirmationValid()
            if passwordConfirmationIsValid {
                let color = UIColor.placeholderGray
                let placeholder = "Password Confirmation" //There should be a placeholder set in storyboard or elsewhere string or pass empty
                passwordConfirmation.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor : color])
            } else {
                passwordConfirmation.text = ""
                let color = UIColor.red
                let placeholder = "Passwords do not match"
                passwordConfirmation.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor : color])
                self.spinner.stopAnimating()
                container.removeFromSuperview()
            }
        }
        if emailIsValid && passwordIsValid && passwordConfirmationIsValid {
            Auth.auth().createUser(withEmail: ValInput.email, password: ValInput.password) { result, error in
                // [START_EXCLUDE]
                if error != nil {
                    self.registerErrorLabel.text = "Something went wrong"
                    self.registerErrorLabel.textColor = .red
                    self.registerErrorLabel.center.y = self.view.center.y + 220
                    self.view.addSubview(self.registerErrorLabel)
                    self.container.removeFromSuperview()
                    self.spinner.stopAnimating()
                    return
                }
                userEmail = self.ValInput.email
                self.spinner.stopAnimating()
                let genderVC = GenderViewController()
                self.navigationController?.pushViewController(genderVC, animated: true)
            }
        }
    }
    
    //MARK: - Helper functions
    func configureUI() {
        registerTitle.text = "Sign up"
        registerTitle.textAlignment = .center
        registerTitle.font = UIFont(name:"Menlo-Bold", size: CGFloat(titleSize))
        registerTitle.textColor = brightPurple
        registerTitle.frame.size.width = 300
        registerTitle.frame.size.height = 100
        registerTitle.center.x = view.center.x
        registerTitle.center.y = view.center.y - 230
        view.addSubview(registerTitle)
        
        signUpView =  UIView(frame: CGRect(x: 100, y: view.center.y + 270, width: buttonWidth, height: 60))
        signUpView.applyDesign(color: lightLavender)
        signUpView.center.x = view.center.x
        signUpView.center.y = view.center.y + registerPadding
        let tap = UITapGestureRecognizer(target: self, action: #selector(tappedRegister))
        signUpView.addGestureRecognizer(tap)
        view.addSubview(signUpView)
        
        signUpLabel.applyDesign(text: "Register")
        signUpLabel.sizeToFit()
        signUpLabel.center.x = view.center.x
        signUpLabel.center.y = view.center.y + registerPadding
        view.addSubview(signUpLabel)
        
        configureNavigationBar(color: .white, isTrans: true)
        loadTextFields()
        loadButtons()
    }
    
    func loadTextFields() {
        view.addSubview(email)
        email.topAnchor.constraint(equalTo: self.registerTitle.bottomAnchor, constant: 15).isActive = true
        email.addDoneButtonOnKeyboard()
        email.applyDesign(view, x: xPadding, y: -170)
        email.placeholder = "Email"
        
        
        password.isSecureTextEntry = true
        view.addSubview(password)
        password.topAnchor.constraint(equalTo: email.bottomAnchor, constant: 28).isActive = true
        password.addDoneButtonOnKeyboard()
        password.applyDesign(view, x: xPadding, y: -65)
        password.placeholder = "Password"
        
        
        passwordConfirmation.isSecureTextEntry = true
        passwordConfirmation.addDoneButtonOnKeyboard()
        view.addSubview(passwordConfirmation)
        passwordConfirmation.topAnchor.constraint(equalTo: password.bottomAnchor, constant: 32).isActive = true
        passwordConfirmation.applyDesign(view, x: xPadding, y: 40)
        passwordConfirmation.placeholder = "Password Confirmation"
        
    }
    
    func showSpinner() {
        spinner.hidesWhenStopped = true
        container.frame = CGRect(x: 0, y: 0, width: 1000, height: 1000)
        container.backgroundColor = .clear
        spinner.center = self.view.center
        view.addSubview(container)
        container.addSubview(spinner)
        spinner.startAnimating()
    }
    
    func loadButtons() {
        view.addSubview(googleImage)
        let tappedGoogle = UITapGestureRecognizer(target: self, action: #selector(googleTapped))
        googleImage.addGestureRecognizer(tappedGoogle)
        googleImage.centerX(to: view)
        googleImage.topToBottom(of: passwordConfirmation, offset: 20)
        googleImage.heightAnchor.constraint(equalToConstant: 50).isActive = true
        googleImage.widthAnchor.constraint(lessThanOrEqualToConstant: lessThanConstant).isActive = true
        googleImage.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: onPad ? 0.4 : 0.8).isActive = true
        googleImage.applyDesign(color: .white)
    }
    
    @objc func googleTapped() {
        GIDSignIn.sharedInstance()?.signIn()
    }
}



