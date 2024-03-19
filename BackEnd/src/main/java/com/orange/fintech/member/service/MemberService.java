package com.orange.fintech.member.service;

import com.orange.fintech.member.entity.Account;
import com.orange.fintech.member.entity.Member;
import com.orange.fintech.oauth.dto.MemberSearchResponseDto;
import org.springframework.stereotype.Service;

import java.util.List;

public interface MemberService {
    MemberSearchResponseDto findByEmail(String email);
    List<Account> findAccountsByKakaoId(Member member);
    Member findByKakaoId(String id);
    boolean logout(String accessToken);
}