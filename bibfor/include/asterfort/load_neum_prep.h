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
interface
    subroutine load_neum_prep(model    , cara_elem , mate      , load_type     , inst_prev,&
                              inst_curr, inst_theta, nb_in_maxi, nb_in_prep    , lchin    ,&
                              lpain    , varc_curr , disp_prev , disp_cumu_inst, compor   ,&
                              carcri   , nharm)
        character(len=24), intent(in) :: model
        character(len=24), intent(in) :: cara_elem
        character(len=24), intent(in) :: mate
        integer, intent(in) :: nb_in_maxi
        character(len=4), intent(in) :: load_type
        real(kind=8), intent(in) :: inst_prev 
        real(kind=8), intent(in) :: inst_curr
        real(kind=8), intent(in) :: inst_theta 
        character(len=8), intent(inout) :: lpain(nb_in_maxi)
        character(len=19), intent(inout) :: lchin(nb_in_maxi)
        integer, intent(out) :: nb_in_prep
        character(len=19), optional, intent(in) :: varc_curr
        character(len=19), optional, intent(in) :: disp_prev
        character(len=19), optional, intent(in) :: disp_cumu_inst
        character(len=24), optional, intent(in) :: compor
        character(len=24), optional, intent(in) :: carcri
        integer, optional, intent(in) :: nharm
    end subroutine load_neum_prep
end interface
