package org.example.casemd3.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.sql.Date;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class User {
    private int user_id;
    private String username;
    private String password;
    private String email;
    private String phone;
    private String image;
    private String address;
    private Date birthday;

}
