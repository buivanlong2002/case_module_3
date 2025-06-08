package org.example.casemd3.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class FaceId {
    private int id;
    private int user_id;
    private String faceIdToken;
}
