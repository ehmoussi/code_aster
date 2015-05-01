!
! COPYRIGHT (C) 1991 - 2015  EDF R&D                WWW.CODE-ASTER.ORG
!
! THIS PROGRAM IS FREE SOFTWARE; YOU CAN REDISTRIBUTE IT AND/OR MODIFY
! IT UNDER THE TERMS OF THE GNU GENERAL PUBLIC LICENSE AS PUBLISHED BY
! THE FREE SOFTWARE FOUNDATION; EITHER VERSION 2 OF THE LICENSE, OR
! (AT YOUR OPTION) ANY LATER VERSION.
!
! THIS PROGRAM IS DISTRIBUTED IN THE HOPE THAT IT WILL BE USEFUL, BUT
! WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED WARRANTY OF
! MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. SEE THE GNU
! GENERAL PUBLIC LICENSE FOR MORE DETAILS.
!
! YOU SHOULD HAVE RECEIVED A COPY OF THE GNU GENERAL PUBLIC LICENSE
! ALONG WITH THIS PROGRAM; IF NOT, WRITE TO EDF R&D CODE_ASTER,
! 1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
!
#include "asterf_types.h"
!
interface 
    subroutine mnlcof(imat, numdrv, matdrv, xcdl, parcho,&
                      adime, xvecu0, xtang, ninc, nd,&
                      nchoc, h, hf, ordman, xups,&
                      xfpnla, lbif, nextr, epsbif)
        integer :: imat(2)
        character(len=14) :: numdrv
        character(len=19) :: matdrv
        character(len=14) :: xcdl
        character(len=14) :: parcho
        character(len=14) :: adime
        character(len=14) :: xvecu0
        character(len=14) :: xtang
        integer :: ninc
        integer :: nd
        integer :: nchoc
        integer :: h
        integer :: hf
        integer :: ordman
        character(len=14) :: xups
        character(len=14) :: xfpnla
        aster_logical :: lbif
        integer :: nextr
        real(kind=8) :: epsbif
    end subroutine mnlcof
end interface 
