!
! COPYRIGHT (C) 1991 - 2016  EDF R&D                WWW.CODE-ASTER.ORG
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
    subroutine nmtble(cont_loop     , model   , mesh  , mate     , ds_contact,&
                      list_func_acti, ds_print, ds_measure, sddyna    ,&
                      sderro        , ds_conv , sddisc, nume_inst,hval_incr  ,&
                      hval_algo)
        use NonLin_Datastructure_type        
        integer, intent(inout) :: cont_loop
        character(len=24), intent(in) :: model
        character(len=8), intent(in) :: mesh
        character(len=24), intent(in) :: mate
        type(NL_DS_Contact), intent(inout) :: ds_contact
        integer, intent(in) :: list_func_acti(*)
        type(NL_DS_Print), intent(inout) :: ds_print
        type(NL_DS_Measure), intent(inout) :: ds_measure
        character(len=19), intent(in) :: sddyna
        character(len=24), intent(in) :: sderro
        type(NL_DS_Conv), intent(in) :: ds_conv
        character(len=19), intent(in) :: sddisc
        integer, intent(in) :: nume_inst
        character(len=19), intent(in) :: hval_incr(*)
        character(len=19), intent(in) :: hval_algo(*)
    end subroutine nmtble
end interface
