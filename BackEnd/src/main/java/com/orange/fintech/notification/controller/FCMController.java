package com.orange.fintech.notification.controller;

import com.orange.fintech.notification.Dto.messageListDataReqDto;
import com.orange.fintech.notification.FcmSender;
import com.orange.fintech.notification.service.FcmService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import java.io.IOException;
import java.security.Principal;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/v1/notification")
@RequiredArgsConstructor
public class FCMController {

    private final FcmSender fcmSender;
    private final FcmService fcmService;

    //    @PostMapping
    //    public ResponseEntity<?> pushInviteMSG(@RequestBody SendFcmDto fcmDto, Principal
    // principal) throws IOException {
    //        System.out.println(
    //                fcmDto.getTargetToken() + " " + fcmDto.getTitle() + " " + fcmDto.getBody());
    //        fcmSender.sendMessageTo(fcmDto.getTargetToken(), fcmDto.getTitle(), fcmDto.getBody());
    //        return ResponseEntity.ok().build();
    //    }

    @PostMapping
    @Operation(summary = "그룹 초대 알림 보내기.", description = "알림DB저장, fcm으로 초대 알림을 보낸다.")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "정상 반환"),
        @ApiResponse(responseCode = "404", description = "계좌 정보 없음 (DB 레코드 유실)"),
        @ApiResponse(responseCode = "500", description = "서버 오류")
    })
    public ResponseEntity<?> pushListDataMSG(
            @RequestBody messageListDataReqDto dto, Principal principal) throws IOException {
        String memberId = principal.getName();
        try {

            return fcmService.pushListDataMSG(dto, memberId);

        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.internalServerError().body("서버 에러");
        }
    }
}