//
//  AppView.swift
//  MyTestApp
//
//  Created by Shamil Aglarov on 29.10.2023.
//

import UIKit

final class AppView {
    
    // Функция для создания UILabel с заданным текстом, размером шрифта, весом шрифта и цветом текста.
    func textLabel(text: String, fontSize: CGFloat = 16, weight: UIFont.Weight = .regular, color: UIColor = .black) -> UILabel {
        let label = UILabel()
        label.text = text // задаем текст для метки
        label.font = UIFont.systemFont(ofSize: fontSize, weight: weight) // устанавливаем размер и вес шрифта
        label.textColor = color // устанавливаем цвет текста
        return label // возвращаем созданную метку
    }
    
    // Функция для создания UIView с определенной шириной и цветом границы.
    func view(borderWidth: CGFloat = 0.5, borderColor: UIColor = .gray) -> UIView {
        let view = UIView()
        view.layer.borderWidth = borderWidth // устанавливаем ширину границы
        view.layer.borderColor = borderColor.cgColor // устанавливаем цвет границы
        return view // возвращаем созданный вид
    }
    
    // Функция для создания UITextField с заданным текстом-заполнителем.
    func textField(placeholder: String,
                   borderStyle: UITextField.BorderStyle = .roundedRect,
                   isSecureTextEntry: Bool = true ) -> UITextField 
    {
        let textField = UITextField()
        textField.placeholder = placeholder // устанавливаем текст-заполнитель
        textField.borderStyle = borderStyle
        textField.isSecureTextEntry = isSecureTextEntry
        return textField // возвращаем созданное текстовое поле
    }
    
    // Функция для создания UIDatePicker с заданным режимом и минимальной датой.
    func datePicker(mode: UIDatePicker.Mode = .dateAndTime, minimumDate: Date = Date()) -> UIDatePicker {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .wheels // устанавливаем предпочтительный стиль датчика даты
        datePicker.minimumDate = minimumDate // устанавливаем минимальную дату
        return datePicker // возвращаем созданный выбор даты
    }
    
    // Функция для создания UITextView с определенной шириной границы, цветом границы и радиусом угла.
    func textView(borderWidth: CGFloat = 0.5, borderColor: UIColor = .black, cornerRadius: CGFloat = 10.0) -> UITextView {
        let textView = UITextView()
        textView.layer.borderWidth = borderWidth // устанавливаем ширину границы
        textView.layer.borderColor = borderColor.cgColor // устанавливаем цвет границы
        textView.layer.cornerRadius = cornerRadius // устанавливаем радиус угла
        return textView // возвращаем созданное текстовое поле
    }
    
    func collectionView(itemSize: CGSize = CGSize(width: UIScreen.main.bounds.width, height: 150),
                              cellType: AnyClass,
                              cellIdentifier: String,
                              backgroundColor: UIColor = .systemBackground,
                              delegate: UICollectionViewDelegate? = nil,
                              dataSource: UICollectionViewDataSource? = nil) -> UICollectionView {
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = itemSize
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = backgroundColor
        collectionView.register(cellType, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.delegate = delegate
        collectionView.dataSource = dataSource
        
        return collectionView
    }
}
