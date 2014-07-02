!
! COPYRIGHT (C) 1991 - 2013  EDF R&D                WWW.CODE-ASTER.ORG
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
    subroutine ircmpe(nofimd, ncmpve, numcmp, exicmp, nbvato,&
                      nbmaec, limaec, adsd, adsl, nbimpr,&
                      ncaimi, ncaimk, tyefma, typmai, typgeo,&
                      nomtyp, typech, profas, promed, prorec,&
                      nroimp, chanom, sdcarm)
        integer :: nbvato
        integer :: ncmpve
        character(len=*) :: nofimd
        integer :: numcmp(ncmpve)
        aster_logical :: exicmp(nbvato)
        integer :: nbmaec
        integer :: limaec(*)
        integer :: adsd
        integer :: adsl
        integer :: nbimpr
        character(len=24) :: ncaimi
        character(len=24) :: ncaimk
        integer :: tyefma(*)
        integer :: typmai(*)
        integer :: typgeo(*)
        character(len=8) :: nomtyp(*)
        character(len=8) :: typech
        integer :: profas(nbvato)
        integer :: promed(nbvato)
        integer :: prorec(nbvato)
        integer :: nroimp(nbvato)
        character(len=19) :: chanom
        character(len=8) :: sdcarm
    end subroutine ircmpe
end interface
